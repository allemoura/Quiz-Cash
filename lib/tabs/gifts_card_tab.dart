import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_cash/model/user_model.dart';
import 'package:quiz_cash/widgets/gift_card.dart';
import 'package:quiz_cash/widgets/top_container.dart';
import 'package:scoped_model/scoped_model.dart';

class GiftsCardTab extends StatefulWidget {
  _GiftsCardTabState createState() => _GiftsCardTabState();
}

class _GiftsCardTabState extends State<GiftsCardTab> {
  double _pontos = 0.1;
  int _moedas = 0;
  double _conversao = 0.0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      _pontos = model.getPontos();
      _moedas = model.getMoedas();
      getConversao();
      return Stack(children: <Widget>[
        SafeArea(
            child: TopContainer(
                height: 140,
                width: width,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.monetization_on,
                            size: 13,
                            color: Colors.amber[300],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Text(
                              '$_moedas',
                              style: TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        '~= R\$${_conversao.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey[800],
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      SizedBox(
                        height: 30,
                        child: RaisedButton(
                          color: Colors.white,
                          onPressed: () {
                            _moedas >= 1000
                                ? alertaConverter()
                                : showColoredToast(
                                    'Você tem que ter no minimo 1000 moedas para converter...');
                          },
                          child: Text(
                            'Converter',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Theme.of(context).primaryColor,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      )
                    ]))),
        Container(
            margin: EdgeInsets.only(top: 145.0),
            child: GridView(
              padding: EdgeInsets.only(bottom: 15.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 2.0,
                childAspectRatio: 1.3,
              ),
              children: <Widget>[
                model.userData['saques'] == 0
                    ? GiftCard(
                        _pontos >= 1.0
                            ? "images/picpayCheio.png"
                            : "images/picpayVazio.png",
                        1,
                        _pontos,
                        'PicPay')
                    : GiftCard(
                        _pontos >= 10.0
                            ? "images/picpayCheio.png"
                            : "images/picpayVazio.png",
                        10,
                        _pontos,
                        'PicPay'),
                GiftCard(
                    _pontos >= 10.0
                        ? "images/ifoodCheio.png"
                        : "images/ifoodVazio.png",
                    10.0,
                    _pontos,
                    "Ifood"),
                GiftCard(
                    _pontos >= 10.0
                        ? "images/paypalCheio.png"
                        : "images/paypalVazio.png",
                    10.0,
                    _pontos,
                    "PayPal"),
                GiftCard(
                    _pontos >= 17.0
                        ? "images/spotifyCheio.png"
                        : "images/spotifyVazio.png",
                    17.0,
                    _pontos,
                    "Spotify"),
                GiftCard(
                    _pontos >= 20.0
                        ? "images/uberCheio.png"
                        : "images/uberVazio.png",
                    20.0,
                    _pontos,
                    "Uber"),
                GiftCard(
                    _pontos >= 20.0
                        ? "images/ifoodCheio.png"
                        : "images/ifoodVazio.png",
                    20.0,
                    _pontos,
                    "Ifood"),
                GiftCard(
                    _pontos >= 20.0
                        ? "images/picpayCheio.png"
                        : "images/picpayVazio.png",
                    20,
                    _pontos,
                    'PicPay'),
                GiftCard(
                    _pontos >= 20.0
                        ? "images/paypalCheio.png"
                        : "images/paypalVazio.png",
                    20.0,
                    _pontos,
                    "PayPal"),
                GiftCard(
                    _pontos >= 30.0
                        ? "images/googlePlayCheio.png"
                        : "images/googlePlayVazio.png",
                    30.0,
                    _pontos,
                    "GooglePlay"),
                GiftCard(
                    _pontos >= 30.0
                        ? "images/uberEatsCheio.png"
                        : "images/uberEatsVazio.png",
                    30.0,
                    _pontos,
                    "Uber Eats"),
                GiftCard(
                    _pontos >= 30.0
                        ? "images/uberCheio.png"
                        : "images/uberVazio.png",
                    30.0,
                    _pontos,
                    "Uber"),
                GiftCard(
                    _pontos >= 30.0
                        ? "images/ifoodCheio.png"
                        : "images/ifoodVazio.png",
                    30.0,
                    _pontos,
                    "Ifood"),
                GiftCard(
                    _pontos >= 30.0
                        ? "images/picpayCheio.png"
                        : "images/picpayVazio.png",
                    30,
                    _pontos,
                    'PicPay'),
                GiftCard(
                    _pontos >= 30.0
                        ? "images/paypalCheio.png"
                        : "images/paypalVazio.png",
                    30.0,
                    _pontos,
                    "PayPal"),
                GiftCard(
                    _pontos >= 35.0
                        ? "images/netflixCheio.png"
                        : "images/netflixVazio.png",
                    35.0,
                    _pontos,
                    "Netflix"),
              ],
            ))
      ]);
    });
  }

  alertaConverter() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        var cancelButton = FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancelar',
              style: TextStyle(
                  fontSize: 15.0,
                  color: Theme.of(context).primaryColor,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700),
            ));
        var simButton = FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              UserModel.of(context).userData['pontos'] =
                  UserModel.of(context).userData['pontos'] + _conversao;
              UserModel.of(context).userData['moedas'] = 0;
              UserModel.of(context).updateUserLocal();
              alertaConvertido(
                  _conversao, UserModel.of(context).userData['pontos']);
            },
            child: Text(
              'Sim',
              style: TextStyle(
                  fontSize: 15.0,
                  color: Theme.of(context).primaryColor,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700),
            ));
        return AlertDialog(
          content: Text(
            'Confirma que quer converter suas moedas?',
            style: TextStyle(
                fontSize: 20.0,
                color: Theme.of(context).primaryColor,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700),
          ),
          actions: [simButton, cancelButton],
        );
      },
    );
  }

  alertaConvertido(double c, double e) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          var okButton = FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Ok',
                style: TextStyle(
                    fontSize: 15.0,
                    color: Theme.of(context).primaryColor,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700),
              ));
          return AlertDialog(
            content: Text(
              'Suas moedas foram convertidas para R\$${c.toStringAsFixed(2)} e agora você tem R\$${e.toStringAsFixed(2)}!',
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey[800],
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700),
            ),
            actions: [okButton],
          );
        });
  }

  void showColoredToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Theme.of(context).primaryColor,
      textColor: Colors.white,
    );
  }

  double getConversao() {
    double c = 0.01 * _moedas;
    _conversao = c / 1000;
  }
}
