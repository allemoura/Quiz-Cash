import 'package:flutter/material.dart';
import 'package:quiz_cash/model/user_model.dart';
import 'package:quiz_cash/screens/termos_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool mostrarSenha = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Cadastrar"),
          centerTitle: true,
        ),
        body:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          if (model.isLoding) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
              key: _formKey,
              child: ListView(padding: EdgeInsets.all(16.0), children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Nome",
                  ),
                  validator: (text) {
                    if (text.isEmpty) return "Nome inválido!";
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "E-mail",
                  ),
                  onEditingComplete: _emailPayPal,
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text.isEmpty || !text.contains("@") || text.length < 4)
                      return "E-mail inválido!";
                  },
                ),
                TextFormField(
                  controller: _senhaController,
                  decoration: InputDecoration(
                    hintText: "Senha",
                  ),
                  obscureText: mostrarSenha,
                  validator: (text) {
                    if (text.isEmpty || text.length < 8)
                      return "Senha inválida!";
                  },
                ),
                SizedBox(height: 20.0),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 16.0,
                        child: Checkbox(
                            activeColor: Theme.of(context).primaryColor,
                            value: !mostrarSenha,
                            onChanged: (bool value) {
                              mostrarSenha = !mostrarSenha == true;
                              setState(() {});
                            }),
                      ),
                      Text(
                        "Mostrar Senha",
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.bold),
                      ),
                    ]),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TermosScreen()));
                  },
                  child: Text(
                    "Ao clicar em cadastrar-se, você está concordando com nosso de Termo de Condições",
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 14.0,
                        fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20.0),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                      child: Text(
                        "Criar Conta",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Map<String, dynamic> userData = {
                            "nome": _nameController.text,
                            "email": _emailController.text,
                            "pontos": 0.01,
                            "vidas": 3,
                            "vidasExtra": 3,
                            'saques': 0,
                            'acertos': 0,
                            "acertosCategorias": {
                              "ciencias": 0,
                              "entretenimento": 0,
                              "geografia": 0,
                              "historia": 0,
                              "literatura": 0,
                              "matematica": 0
                            },
                            'tentarNovamenteEstado': true,
                            'tentarNovamente': 3,
                            'assistirVideo': 20,
                            'moedas': 0,
                            'pontosDiarios': 0
                          };

                          model.signUp(
                              userData: userData,
                              pass: _senhaController.text,
                              onSuccess: _onSuccess,
                              onFail: _onFail);
                        }
                      }),
                ),
              ]));
        }));
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Usuário criado com sucesso!!"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 3),
    ));
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar usuário !!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }

  void _emailPayPal() {
    if (mounted) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content:
            Text("Certifique-se que seu email é o mesmo da sua conta PayPal!!"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 5),
      ));
    }
    /*Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });*/
  }
}
