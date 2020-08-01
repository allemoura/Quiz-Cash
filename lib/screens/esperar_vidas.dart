import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_cash/model/user_model.dart';
import 'package:quiz_cash/screens/categorias_quiz_screen.dart';
import 'package:quiz_cash/screens/home_screen.dart';
import 'package:unity_ads_flutter/unity_ads_flutter.dart';

const String videoPlacementId = 'GanharVidas';
const String gameIdAndroid = '3714065';
const String gameIdIOS = '3714064';

class EsperarVidaScreen extends StatefulWidget {
  int horas;
  int min;
  int seg;
  final String tempo;

  EsperarVidaScreen(this.tempo);

  _EsperarVidaScreenState createState() => _EsperarVidaScreenState(tempo);
}

class _EsperarVidaScreenState extends State<EsperarVidaScreen>
    with UnityAdsListener {
  final String tempo;
  bool _ready;
  bool inicio;

  int horasStart;
  int minStart;
  int segundosStart;
  int start;
  bool completo = false;
  String showTimer;

  bool cancelTimer = false;
  Timer timer;
  bool _iniciado = false;

  //bool _isRewardedAdLoaded = false;
  _EsperarVidaScreenState(this.tempo);

  @override
  void initState() {
    super.initState();
    UnityAdsFlutter.initialize(gameIdAndroid, gameIdIOS, this, false);
    List<String> restante = tempo.split(":");
    horasStart = int.parse(restante[0]);
    minStart = int.parse(restante[1]);
    String tmp = restante[2][0] + restante[2][1];
    segundosStart = int.parse(tmp);

    start = horasStart;
    showTimer =
        "${horasStart.toString()}:${minStart.toString()}:${segundosStart.toString()}";
    inicio = true;
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: GestureDetector(
              child: Icon(Icons.home, color: Colors.white, size: 35.0),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
            centerTitle: true),
        backgroundColor: Color(0xff80d8c8),
        body: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Poxa, suas vidas acabaram!",
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
                  textAlign: TextAlign.center,
                ),
                Image.asset("images/coracao.png"),
                SizedBox(height: 10.0),
                Padding(
                  padding:
                      EdgeInsets.only(left: 18.0, right: 18.0, bottom: 14.0),
                  child: Text(
                    "Mas não têm problema, você pode esperar 3 horas ou assistir a 3 vídeos e suas vidas serão restauradas!!",
                    style: TextStyle(
                      color: Colors.grey[100],
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.only(
                        left: 80, bottom: 15.0, top: 15.0, right: 82),
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                              14.0), //                 <--- border radius here
                        ),
                        color: Colors.white),
                    child: Padding(
                        padding: EdgeInsets.only(left: 0.0),
                        child: Text(
                          showTimer,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ))),
                Container(
                    //height:50.0,
                    //width: 180.0,
                    margin: EdgeInsets.only(left: 98.0, right: 98.0),
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        if (mounted) {
                          UnityAdsFlutter.show('GanharVidas');

                          showColoredToast(
                              "Um anúncio está sendo carregado, aguarde!");
                        } else {
                          showColoredToast(
                              "Ops, parece que um erro ocorreu, tente novamente em segundos!");
                        }
                      },
                      child: Row(children: <Widget>[
                        Icon(Icons.movie),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Text("Assitir Vídeo"),
                        )
                      ]),
                    )),
              ])),
        ));
  }

  void showColoredToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Theme.of(context).primaryColor,
      textColor: Colors.white,
    );
  }

  startTimer() {
    if (mounted) {
      const onesec = Duration(seconds: 1);
      Timer.periodic(onesec, (t) {
        timer = t;

        if (horasStart == 0 && minStart == 0 && segundosStart == 0) {
          timer.cancel();
          try {
            UserModel.of(context).userData['vidas'] = 3;
            UserModel.of(context).userData['vidasExtra'] = 3;
            UserModel.of(context).updateUserLocal();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => CategoriasQuizScreen()));
          } catch (e) {}
        } else {
          if (horasStart >= 0 && minStart >= 0 && segundosStart >= 0) {
            /*if(inicio){
                inicio = false;
                if(horasStart > 1){
                  horasStart -= 1;
                }

              }*/
            if (segundosStart == 0 && minStart > 0) {
              minStart -= 1;
              if (minStart > 0 && horasStart >= 0) {
                segundosStart = 60;
              }
              if (segundosStart == 0 && minStart == 0 && horasStart > 1) {
                horasStart -= 1;
              }
            } else if (segundosStart > 0) {
              if (minStart == 0 && horasStart > 0) {
                segundosStart = 60;
              } else {
                segundosStart -= 1;
              }
            } else if (segundosStart == 0 && minStart == 0 && horasStart > 0) {
              segundosStart = 60;
              minStart = 60;
            }
          }
        }

        showTimer =
            "0${horasStart.toString()}:${minStart < 10 ? "0" : ""}${minStart.toString()}:${segundosStart < 10 ? "0" : ""}${segundosStart.toString()}";
        setState(() {});
      });
    }
  }

  @override
  void onUnityAdsFinish(String placementId, FinishState result) {
    if (result == FinishState.completed) {
      setState(() async {
        if (horasStart == 0) {
          minStart = 0;
          segundosStart = 0;
        } else {
          horasStart -= 1;
        }
      });
    }
  }

  @override
  void onUnityAdsError(UnityAdsError error, String message) {
    showColoredToast('Ops, algo deu errado, tente novamente...');
  }

  @override
  void onUnityAdsReady(String placementId) {
    if (placementId == videoPlacementId) {
      setState(() {
        _ready = true;
        _iniciado = true;
      });
    }
  }

  @override
  void onUnityAdsStart(String placementId) {
    if (placementId == videoPlacementId) {
      setState(() {
        _ready = false;
        _iniciado = false;
      });
    }
  }
}
