import 'package:flutter/material.dart';
import 'package:quiz_cash/model/user_model.dart';
import 'package:quiz_cash/screens/reset_screen.dart';

class PerfilTab extends StatefulWidget {
  @override
  _PerfilTabState createState() => _PerfilTabState();
}

class _PerfilTabState extends State<PerfilTab> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _nameController.text = UserModel.of(context).userData['nome'];
    _emailController.text = UserModel.of(context).userData['email'];
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
              hintText: "Seu E-mail",
            ),
            validator: (text) {
              if (text.isEmpty) return "E-mail inválido!";
            },
          ),
          SizedBox(height: 16.0),
          SizedBox(height: 16.0),
          SizedBox(
            height: 44.0,
            child: RaisedButton(
              child: Text(
                "Alterar Cadastro",
                style: TextStyle(fontSize: 18.0),
              ),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  if (_emailController.text !=
                      UserModel.of(context).userData['email']) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ResetScreen(
                            _emailController.text, _nameController.text)));
                  } else {
                    UserModel.of(context).userData['nome'] =
                        _nameController.text;
                    UserModel.of(context).updateUserLocal();
                  }
                }
              },
            ),
          ),
        ]));
  }

  void onSuccess() {
    showDialog(
        context: context,
        builder: (context) {
          Widget okButton = FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'ok',
                style: TextStyle(color: Colors.white),
              ));

          AlertDialog alert = AlertDialog(
            content: Text(
              'Usuário atualizado com sucesso!!',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).primaryColor,
            actions: [
              okButton,
            ],
          );

          return alert;
        });
  }

  void onFail() {
    showDialog(
        context: context,
        builder: (context) {
          Widget okButton = FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'ok',
                style: TextStyle(color: Colors.white),
              ));

          AlertDialog alert = AlertDialog(
            content: Text(
              'Falha ao atualizar usuário, tente novamente!!',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).primaryColor,
            actions: [
              okButton,
            ],
          );
          return alert;
        });
  }
}
