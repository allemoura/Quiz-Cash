import 'package:flutter/material.dart';
import 'package:quiz_cash/model/user_model.dart';
import 'package:quiz_cash/screens/historico_saque_screen.dart';
import 'package:quiz_cash/screens/login_screen.dart';
import 'package:quiz_cash/screens/perfil_screen.dart';
import 'package:quiz_cash/screens/termos_screen.dart';
import 'package:quiz_cash/widgets/top_container.dart';

class InformacoesTab extends StatefulWidget {
  @override
  _InformacoesTabState createState() => _InformacoesTabState();
}

class _InformacoesTabState extends State<InformacoesTab> {
  double _pontos = 0.0;
  int _moedas = 0;

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      _pontos = UserModel.of(context).getPontos();
      _moedas = UserModel.of(context).getMoedas();
      double width = MediaQuery.of(context).size.width;
      return SafeArea(
          child: Column(
        children: <Widget>[
          TopContainer(
            height: 140,
            width: width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.only(right: 8.0, top: 20.0),
                          padding: const EdgeInsets.all(3.0),
                          decoration: new BoxDecoration(
                            border: new Border.all(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(
                                    14.0) //                 <--- border radius here
                                ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                'images/notas.png',
                                width: 25.0,
                                height: 25.0,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 2.0, bottom: 4.8, right: 2.0),
                                child: Text(
                                  "R\$${_pontos.toStringAsFixed(2)}",
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          )),
                      Container(
                          margin: const EdgeInsets.only(right: 8.0, top: 20.0),
                          padding: const EdgeInsets.all(3.0),
                          decoration: new BoxDecoration(
                            border: new Border.all(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(
                                    14.0) //                 <--- border radius here
                                ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.monetization_on,
                                color: Colors.amber[300],
                                size: 26.0,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 2.0, bottom: 4.8, right: 2.0),
                                child: Text(
                                  "R\$$_moedas",
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                  Icon(
                    Icons.account_circle,
                    size: 85.0,
                    color: Colors.grey[100],
                  ),
                ]),
          ),
          SizedBox(
            height: 30.0,
          ),
          GestureDetector(
            child: SizedBox(
                height: 60.0,
                width: 320.0,
                child: Card(
                    //color: Colors.grey[100],
                    child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Meus Dados",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ))),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PerfilScreen()));
            },
          ),
          GestureDetector(
            child: SizedBox(
                height: 60.0,
                width: 320.0,
                child: Card(
                    //color: Colors.grey[100],
                    child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Historico de Saques",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ))),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HistoricoSaqueScreen()));
            },
          ),
          GestureDetector(
            child: SizedBox(
                height: 60.0,
                width: 320.0,
                child: Card(
                    //color: Colors.grey[100],
                    child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Termos de Condições",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ))),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TermosScreen()));
            },
          ),
        ],
      ));
    } else {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 80.0,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Faça o login para Acessar!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16.0,
            ),
            RaisedButton(
              child: Text(
                "Entrar",
                style: TextStyle(fontSize: 18.0),
              ),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            )
          ],
        ),
      );
    }
  }
}
