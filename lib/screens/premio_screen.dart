import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_cash/model/user_model.dart';

class PremioScreen extends StatefulWidget {
  final double valor;
  final String image;
  final bool sacar;
  final String nomePremio;
  final double pontuacao;

  PremioScreen(
      this.sacar, this.image, this.valor, this.nomePremio, this.pontuacao);

  @override
  _PremioScreenState createState() =>
      _PremioScreenState(sacar, image, valor, nomePremio, pontuacao);
}

class _PremioScreenState extends State<PremioScreen> {
  final double valor;
  final String image;
  final bool sacar;
  final String nomePremio;
  final double pontuacao;
  final _userController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _PremioScreenState(
      this.sacar, this.image, this.valor, this.nomePremio, this.pontuacao);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //BannerAd _bannerAd;

  /*static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>[
      'gamer',
      'cash',
      'midias',
      'jogo',
      'dinheiro',
      'tecnologia'
    ],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: false,
    nonPersonalizedAds: false,
  );*/

  @override
  void initState() {
    super.initState();
    //_bannerAd = createBannerAd()..load();
    //displayBanner();
  }

  @override
  void dispose() {
    //_bannerAd?.dispose();
    super.dispose();
  }

  /*BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: "ca-app-pub-1841433718864307/2128014550",
      size: AdSize.fullBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  displayBanner() {
    _bannerAd ??= createBannerAd();
    _bannerAd
      ..load()
      ..show();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text("Informações do Premio"), centerTitle: true),
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Image.asset(
                    image,
                    height: 220.0,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 20.0),
                    child: sacar
                        ? Text(
                            "O seu prêmio sera compensado de 3-15 dias úteis.\n" +
                                "Usaremos seu e-mail para avisa-lo que seu saque foi efetuado ou caso acontece algum problema na transação." +
                                "\nCaso tenha selecionado o PayPal, antes confirmar certifique-se que seu e-mail no nosso aplicativo é mesmo da sua conta. " +
                                "E em caso de PicPay adicione corretamente o user da sua conta, para que não seja enviado para a pessoa errada (não nós responsabilizamos caso você adicione o usuario errado)!" +
                                "\nCaso seja descoberto algum tipo de falcatrua seu prêmio pode ser revogado, siga as nossos normas de uso.\n" +
                                "Em caso de dúvidas entrar em contato pelo e-mail mouracode@gmail.com.",
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          )
                        : Text(
                            "Para conquistar esse prêmio você precisa de R\$${valor > pontuacao ? (valor - pontuacao).toStringAsFixed(2) : (pontuacao - valor).toStringAsFixed(2)}!\n" +
                                " Em caso de dúvidas entrar em contato pelo e-mail mouracode@gmail.com.",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          )),
                //SizedBox(height: 14.0),
                SizedBox(
                    height: 40.0,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 5.0),
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        disabledColor: Colors.grey[300],
                        onPressed: sacar
                            ? () {
                                nomePremio == 'PicPay'
                                    ? recebeUser()
                                    : fazSaque();
                              }
                            : null,
                        child: Text(
                          "Confirmar",
                          style: TextStyle(color: Colors.amber[300]),
                        ),
                      ),
                    ))
              ]),
        ));
  }

  void recebeUser() {
    showDialog(
      context: context,
      builder: (context) {
        var okButton = FlatButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                fazSaque();
              }
            },
            child: Text("ok"));
        var cancelarButton = FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'));
        return AlertDialog(
          title: Text('Insira seu user do PicPay!!'),
          content: Form(
              key: _formKey,
              child: TextFormField(
                controller: _userController,
                decoration: InputDecoration(
                  hintText: "Insira aqui...",
                ),
                keyboardType: TextInputType.name,
                validator: (text) {
                  if (text.isEmpty)
                    return "Preencha o campo antes de confirmar!";
                },
              )),
          actions: [okButton, cancelarButton],
        );
      },
    );
  }

  Future<void> fazSaque() async {
    String user = UserModel.of(context).firebaseUser.uid;

    Map<String, dynamic> data = {
      "clienteId": user,
      "data": Timestamp.now(),
      "nome": nomePremio,
      "processado": "",
      "status": 1,
      "valor": valor,
    };
    if (nomePremio == 'PicPay') {
      data['user'] = _userController.text;
    }

    DocumentReference refSaques =
        await Firestore.instance.collection("saques").add(data);
    try {
      data["saquesId"] = refSaques.documentID;
      Firestore.instance
          .collection("users")
          .document(user)
          .collection("saques")
          .document(refSaques.documentID)
          .setData(data);
      UserModel.of(context).userData['pontos'] = pontuacao - valor;
      UserModel.of(context).userData['saques'] =
          UserModel.of(context).userData['saques'] + 1;
      UserModel.of(context).updateUserLocal();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Premio confirmado com sucesso!!"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 3),
      ));
      Future.delayed(Duration(seconds: 2)).then((_) {
        Navigator.of(context).pop();
      });
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Falha ao tentar confirmar, tente novamente!!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ));
    }
  }
}
