import 'package:applovin/applovin.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_cash/controller/quiz_controller.dart';
import 'package:quiz_cash/model/user_model.dart';
import 'package:quiz_cash/screens/categorias_quiz_screen.dart';
import 'package:quiz_cash/screens/home_screen.dart';
import 'package:quiz_cash/screens/quiz_screen.dart';
//import 'package:unity_ads_flutter/unity_ads_flutter.dart';

/*const String videoPlacementId = 'TentarNovamente';
const String gameIdAndroid = '3714065';
const String gameIdIOS = '3714064';*/

class ErrouScreen extends StatefulWidget {
  final QuizController quizController;
  final String categoria;
  final String titulo;

  ErrouScreen(this.quizController, this.categoria, this.titulo);

  @override
  _ErrouScreenState createState() => _ErrouScreenState();
}

class _ErrouScreenState extends State<ErrouScreen> /*with UnityAdsListener */ {
  bool _ready;
  bool _iniciado = false;

  initState() {
    AppLovin.init();
    super.initState();
    //UnityAdsFlutter.initialize(gameIdAndroid, gameIdIOS, this, false);
  }

  @override
  void dispose() {
    //rewardAd?.dispose();
    super.dispose();
  }

  void showColoredToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Theme.of(context).primaryColor,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff80d8c8),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(18.0),
                  child: Center(
                      child: Text(
                    widget.titulo,
                    style: TextStyle(fontSize: 30.0, color: Colors.white),
                  )),
                ),
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 140.0,
                ),
                Container(
                  margin: EdgeInsets.all(18.0),
                  child: Center(
                      child: Text(
                    "Mas fica tranquilo, você pode assistir um vídeo e voltar ao jogo ou escolher outra categoria!!\n\nVocê conseguiu R\$${widget.quizController.getPontos().toStringAsFixed(3)} nessa rodada e acertou ${widget.quizController.hitNumber} pergunta(s)!",
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  )),
                ),
                Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: SizedBox(
                            height: 40.0,
                            child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                child: Text("Assistir Video",
                                    style: TextStyle(color: Colors.amber[300])),
                                onPressed: () {
                                  if (mounted) {
                                    AppLovin.requestInterstitial(
                                        (AppLovinAdListener event) =>
                                            listener(event, true),
                                        interstitial: true);
                                    //UnityAdsFlutter.show('TentarNovamente');

                                  } else {
                                    showColoredToast(
                                        "Ops, parece que um erro ocorreu, tente novamente em segundos!");
                                  }
                                }))),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: SizedBox(
                          height: 40.0,
                          child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              child: Text(
                                "Escolher Categoria",
                                style: TextStyle(color: Colors.amber[300]),
                              ),
                              onPressed: () {
                                widget.quizController.getProximaQuestao();
                                widget.quizController.resetPontos();
                                if (UserModel.of(context).userData['vidas'] >
                                    0) {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CategoriasQuizScreen()));
                                } else {
                                  Future.delayed(Duration(seconds: 2), () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen()));
                                  });

                                  showColoredToast(
                                      'Ops, suas vidas acabaram...');
                                }
                              })),
                    ),
                  )
                ])
              ]),
        ));
  }

  listener(AppLovinAdListener event, bool isInter) {
    print(event);
    if (event == AppLovinAdListener.adReceived) {
      showColoredToast("Um anúncio está sendo carregado, aguarde!");
      AppLovin.showInterstitial(interstitial: isInter);
    }
    if (event == AppLovinAdListener.failedToReceiveAd) {
      showColoredToast('Ops, algo deu errado, tente novamente...');
    }
    if (event == AppLovinAdListener.videoPlaybackEnded) {
      widget.quizController.getProximaQuestao();
      widget.quizController.hitNumber = 0;
      widget.quizController.acertos = List();
      widget.quizController.resetPontos();
      UserModel.of(context).userData['vidasExtra'] =
          UserModel.of(context).userData['vidasExtra'] - 1;
      UserModel.of(context).updateUserLocal();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              QuizScreen(widget.categoria, widget.quizController)));
    }
  }

  alertaSemVida() {
    showDialog(
      context: context,
      builder: (context) {
        var buttonOk = FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            child: Text(
              "ok",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ));
        return AlertDialog(
          title: Text("Ops, suas vidas acabaram"),
          content: Icon(
            Icons.sentiment_dissatisfied,
            color: Theme.of(context).primaryColor,
            size: 40.0,
          ),
          actions: [buttonOk],
        );
      },
    );
  }

  /*@override
  void onUnityAdsFinish(String placementId, FinishState result) {
    if (result == FinishState.completed) {
      widget.quizController.getProximaQuestao();
      widget.quizController.hitNumber = 0;
      widget.quizController.acertos = List();
      widget.quizController.resetPontos();
      UserModel.of(context).userData['vidasExtra'] =
          UserModel.of(context).userData['vidasExtra'] - 1;
      UserModel.of(context).updateUserLocal();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              QuizScreen(widget.categoria, widget.quizController)));
    } else {
      showColoredToast(
          "Ops, parece que um erro ocorreu, tente novamente em segundos!");
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
        _iniciado = false;
      });
    }
  }

  @override
  void onUnityAdsStart(String placementId) {
    if (placementId == videoPlacementId) {
      setState(() {
        _iniciado = false;
        _ready = false;
      });
    }
  }*/
}
