import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_cash/controller/quiz_controller.dart';
import 'package:quiz_cash/model/user_model.dart';
import 'package:quiz_cash/screens/categorias_quiz_screen.dart';
import 'package:quiz_cash/screens/errou_screen.dart';
import 'package:quiz_cash/screens/home_screen.dart';
import 'package:quiz_cash/screens/splash/acabou_screen.dart';
import 'package:quiz_cash/screens/splash/sem_vidas_extra_screen.dart';
import 'package:unity_ads_flutter/unity_ads_flutter.dart';

const List<String> videoPlacementId = ['Pular', 'Dicas', 'Tentar', 'perguntas'];
const String gameIdAndroid = '3714065';
const String gameIdIOS = '3714064';

class QuizScreen extends StatefulWidget {
  final String categoria;
  final QuizController quizController;

  QuizScreen(this.categoria, this.quizController);

  @override
  _QuizScreenState createState() => _QuizScreenState(categoria, quizController);
}

class _QuizScreenState extends State<QuizScreen> with UnityAdsListener {
  final String categoria;
  final QuizController quizController;
  Timer _timer;
  List<bool> tocavel = [true, true, true, true, true];
  String opcaoAjuda = "";
  bool estadoPerguntas = false;
  bool limite = false;

  _QuizScreenState(this.categoria, this.quizController);

  int timer = 90;
  String showTimer = '90';
  bool cancelTimer = false;
  int contResp = 0;
  int chanceTentarNovamente = 3;
  int chanceBomba = 3;
  int chancePular = 3;
  bool acertou = false;
  bool completo = false;
  bool _ready;
  bool _iniciado = false;

  @override
  void initState() {
    super.initState();
    startTimer(Duration(seconds: 1));
    //AppLovin.init();
    UnityAdsFlutter.initialize(gameIdAndroid, gameIdIOS, this, false);
  }

  @override
  void dispose() {
    //_interstitialAd?.dispose();
    _timer.cancel();

    super.dispose();
  }

  void showColoredToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Theme.of(context).primaryColor,
      textColor: Colors.white,
    );
  }

  tentarNovamenteAjuda() {
    tocavel = [true, true, true, true, true];
    timer = 90;
    showTimer = "90";
    startTimer(Duration(seconds: 1));
  }

  /*InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: "ca-app-pub-3940256099942544/1033173712",
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");

        if (event == MobileAdEvent.closed) {
          if (acertou) {
            respostaVerdadeira();
          } else {
            if (chanceTentarNovamente > 0) {
              alertaComChance();
            } else {
              analisaErro();
            }
          }
        }
      },
    );
  }*/

  pularQuestao() {
    tocavel = [true, true, true, true, true];
    quizController.getProximaQuestao();
    timer = 90;
    showTimer = '90';
    startTimer(Duration(seconds: 1));
  }

  alertaAjuda() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        var buttonMoedas = FlatButton(
            onPressed: () {
              Navigator.of(context).pop();

              UserModel.of(context).userData['moedas'] =
                  UserModel.of(context).userData['moedas'] - 10;
              UserModel.of(context).updateUserLocal();

              if (opcaoAjuda == "eliminar") {
                elimarRespostas();
              } else if (opcaoAjuda == "tentar") {
                tentarNovamenteAjuda();
              } else if (opcaoAjuda == "pular") {
                pularQuestao();
              }
            },
            child: Text("Moedas",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                )));
        var buttonVideo = FlatButton(
            onPressed: () {
              Navigator.of(context).pop();

              showColoredToast("Um anúncio está sendo carregado, aguarde!");
              if (opcaoAjuda == "eliminar") {
                chanceBomba--;
                UnityAdsFlutter.show('Dicas');
              } else if (opcaoAjuda == "tentar") {
                chanceTentarNovamente--;
                UnityAdsFlutter.show('Tentar');
              } else if (opcaoAjuda == "pular") {
                chancePular--;
                UnityAdsFlutter.show('Pular');
              }

              //tentarNovamenteAjuda();
            },
            child: Text("Assistir Video",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                )));
        return AlertDialog(
          content: Text("Você quer assistir vídeo ou gastar 10 moedas?"),
          actions: [buttonMoedas, buttonVideo],
        );
      },
    );
  }

  alertaComChance() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          var buttonNao = FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                analisaErro();
              },
              child: Text("Não",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  )));
          var buttonSim = FlatButton(
              onPressed: () {
                opcaoAjuda = 'tentar';
                Navigator.of(context).pop();
                if (UserModel.of(context).userData['moedas'] < 10) {
                  chanceTentarNovamente--;
                  UnityAdsFlutter.show('Tentar');
                } else if (chanceTentarNovamente == 0) {
                  UserModel.of(context).userData['moedas'] =
                      UserModel.of(context).userData['moedas'] - 10;
                  UserModel.of(context).updateUserLocal();
                  tentarNovamenteAjuda();
                } else {
                  alertaAjuda();
                }

                //tentarNovamenteAjuda();
              },
              child: Text("Sim",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  )));
          return AlertDialog(
            content: Text(
                "Você quer tentar essa questão novamente?\n Ainda tem $chanceTentarNovamente chances de tentar assistindo apenas um vídeo..."),
            actions: [buttonSim, buttonNao],
          );
        });
  }

  startTimer(Duration duration) {
    if (mounted) {
      Duration onesec = duration;
      Timer.periodic(onesec, (Timer t) {
        if (mounted) {
          _timer = t;
          setState(() {
            if (timer < 1) {
              if (quizController.getPontos() > 0.0) {
                UserModel.of(context).userData['acertos'] =
                    UserModel.of(context).userData['acertos'] +
                        quizController.hitNumber;
                UserModel.of(context).userData['pontos'] =
                    UserModel.of(context).userData['pontos'] +
                        quizController.getPontos();
                UserModel.of(context).userData['pontosDiariosData'] =
                    Timestamp.now();

                UserModel.of(context).updateUserLocal();
              }
              if (UserModel.of(context).userData['vidasExtra'] > 0) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ErrouScreen(quizController, categoria,
                        "Ops, seu tempo acabou :(")));
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => CategoriasQuizScreen()));
              }
            } else {
              timer = timer - 1;
            }
            showTimer = timer.toString();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          showTimer,
          style: TextStyle(fontSize: 20.0, color: Colors.amber[400]),
        ),
        centerTitle: true,
        actions: [
          FlatButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      var buttomSair = FlatButton(
                          padding: EdgeInsets.only(right: 100.0),
                          onPressed: () {
                            if (quizController.getPontos() > 0.0) {
                              UserModel.of(context).userData['acertos'] =
                                  UserModel.of(context).userData['acertos'] +
                                      quizController.hitNumber;
                              UserModel.of(context).userData['pontos'] =
                                  UserModel.of(context).userData['pontos'] +
                                      quizController.getPontos();
                              UserModel.of(context).updateUserLocal();
                            }
                            Navigator.of(context).pop();
                            if (UserModel.of(context).userData['vidas'] == 0) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            } else {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CategoriasQuizScreen()));
                            }
                          },
                          child: Text(
                            "Sair",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.0),
                          ));
                      var buttomCancelar = FlatButton(
                          padding: EdgeInsets.only(right: 30.0),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Cancelar",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.0),
                          ));
                      return AlertDialog(
                        title: Text(
                          "Sair do Quiz",
                        ),
                        content: Text(
                          "Tem certeza disso?",
                          textAlign: TextAlign.center,
                        ),
                        actions: [buttomSair, buttomCancelar],
                      );
                    });
              },
              child: Container(
                  child: Icon(
                Icons.cancel,
                color: Colors.white,
                size: 30.0,
              )))
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
            Widget>[
          Container(
            padding: const EdgeInsets.all(3.0),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
            decoration: new BoxDecoration(
                border: new Border.all(color: Colors.grey[200]),
                borderRadius: BorderRadius.all(Radius.circular(
                        14.0) //                 <--- border radius here
                    ),
                color: Colors.grey[200]),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: 4.0, right: 20.0, left: 8.0, bottom: 8.0),
                    child: Text(
                      "Pontuação: R\$${quizController.getPontos().toStringAsFixed(3)}",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 4.0, bottom: 8.0, right: 30.0),
                    child: Text(
                      "Acertos: ${quizController.hitNumber}",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: Padding(
                padding: EdgeInsets.only(bottom: 6.0),
                child: SingleChildScrollView(
                  child: Text(
                    quizController.getQuestao(),
                    style: TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[800]),
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
          Expanded(child: resposta(quizController.getResposta1(), 0)),
          Expanded(child: resposta(quizController.getResposta2(), 1)),
          Expanded(child: resposta(quizController.getResposta3(), 2)),
          Expanded(child: resposta(quizController.getResposta4(), 3)),
          Expanded(child: resposta(quizController.getResposta5(), 4)),
          Expanded(
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      GestureDetector(
                        child: opcoesAjuda(
                            "Pular Questão",
                            chancePular.toString(),
                            Icon(
                              Icons.skip_next,
                              color: Theme.of(context).primaryColor,
                              size: 30,
                            )),
                        onTap: () {
                          if (chancePular > 0 ||
                              UserModel.of(context).userData['moedas'] >= 10) {
                            _timer.cancel();

                            opcaoAjuda = 'pular';
                            if (UserModel.of(context).userData['moedas'] < 10) {
                              showColoredToast(
                                  "Um anúncio está sendo carregado, aguarde!");
                              UnityAdsFlutter.show('Pular');

                              chancePular--;
                            } else if (chancePular == 0) {
                              Navigator.of(context).pop();
                              UserModel.of(context).userData['moedas'] =
                                  UserModel.of(context).userData['moedas'] - 10;
                              UserModel.of(context).updateUserLocal();

                              pularQuestao();
                            } else {
                              alertaAjuda();
                            }
                          } else {
                            showColoredToast(
                                'Ops, você não tem mais vídeos nem moedas suficienter');
                          }
                          //executaVideo();
                        },
                      ),
                      GestureDetector(
                        child: opcoesAjuda(
                            "Dicas",
                            chanceBomba.toString(),
                            Icon(
                              Icons.help_outline,
                              color: Theme.of(context).primaryColor,
                              size: 30,
                            )),
                        onTap: () {
                          if (chanceBomba > 0 ||
                              UserModel.of(context).userData['moedas'] >= 10) {
                            _timer.cancel();

                            opcaoAjuda = 'eliminar';
                            if (UserModel.of(context).userData['moedas'] < 10) {
                              showColoredToast(
                                  "Um anúncio está sendo carregado, aguarde!");
                              UnityAdsFlutter.show('Dicas');

                              chanceBomba--;
                            } else if (chanceTentarNovamente == 0) {
                              Navigator.of(context).pop();
                              UserModel.of(context).userData['moedas'] =
                                  UserModel.of(context).userData['moedas'] - 10;
                              UserModel.of(context).updateUserLocal();

                              elimarRespostas();
                            } else {
                              alertaAjuda();
                            }
                          } else {
                            showColoredToast(
                                'Ops, você não tem mais vídeos nem moedas suficienter');
                          }
                        },
                      ),
                      opcoesAjuda(
                          "Tentar Novamente",
                          chanceTentarNovamente.toString(),
                          Icon(
                            Icons.refresh,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          )),
                    ],
                  )))
        ]),
      ),
    );
  }

  elimarRespostas() {
    startTimer(Duration(seconds: 1));
    int posCorreta = quizController.getPosRespostaCorreta();
    int i = 0;
    List<int> salvo = [];
    while (i < 3) {
      int pos = Random().nextInt(5);
      if (pos != posCorreta && !salvo.contains(pos)) {
        salvo.add(pos);
        i++;
        tocavel[pos] = false;
      }
    }
    setState(() {});
  }

  Widget opcoesAjuda(String nome, String chance, Icon icon) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          nome,
          style:
              TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w800),
        ),
        Row(
          children: <Widget>[
            icon,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(
                  Icons.monetization_on,
                  size: 13,
                  color: Colors.amber[300],
                ),
                Text(
                  '10',
                  style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              ],
            )
          ],
        ),
      ],
    ));
  }

  alertaLimiteQuiz() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          var buttonOk = FlatButton(
              onPressed: () {
                Navigator.of(context).pop();

                UserModel.of(context).userData['pontosDiariosData'] =
                    Timestamp.now();
                UserModel.of(context).userData['vidas'] = 0;
                UserModel.of(context).updateUserLocal();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: Text("Ok",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  )));
          return AlertDialog(
            content: Text("Você atingiu o limite diario de pontos..."),
            actions: [buttonOk],
          );
        });
  }

  Widget resposta(String resposta, int pos) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.15,
        child: GestureDetector(
          child: Card(
            color: tocavel[pos] ? Colors.white : Colors.grey,
            margin: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Column(children: <Widget>[
              Expanded(
                  child: Center(
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    resposta,
                    style: TextStyle(color: Colors.grey[800], fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ))
            ]),
          ),
          onTap: tocavel[pos]
              ? () async {
                  ++contResp;
                  _timer.cancel();
                  setState(() {});
                  acertou = quizController.getRespostaCorreta(resposta);

                  if (acertou) {
                    UserModel.of(context).userData['pontosDiarios'] =
                        UserModel.of(context).userData['pontosDiarios'] + 1;
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 1), () {
                          Navigator.of(context).pop();
                          if (contResp == 4) {
                            estadoPerguntas = true;
                            contResp = 0;
                            alertaContinuar();
                          } else {
                            respostaVerdadeira();
                          }
                        });
                        return AlertDialog(
                          title: Text("Você acertou!!"),
                          content: Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 40.0,
                          ),
                        );
                      },
                    );

                    //respostaVerdadeira();
                  } else {
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 1), () {
                          Navigator.of(context).pop();
                          if (chanceTentarNovamente > 0 ||
                              UserModel.of(context).userData['moedas'] >= 10) {
                            if (contResp == 4) {
                              contResp = 0;
                              estadoPerguntas = true;
                              alertaContinuar();
                            } else {
                              alertaComChance();
                            }
                          } else {
                            if (contResp == 4) {
                              contResp = 0;
                              estadoPerguntas = true;

                              alertaContinuar();
                            } else {
                              analisaErro();
                            }
                          }
                        });

                        return AlertDialog(
                          title: Text("Você errou :("),
                          content: Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 40.0,
                          ),
                        );
                      },
                    );
                  }
                }
              : null,
        ));
  }

  alertaContinuar() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          var buttonAssistir = FlatButton(
              onPressed: () {
                Navigator.of(context).pop();

                UnityAdsFlutter.show('perguntas');
                showColoredToast("Um anúncio está sendo carregado, aguarde!");
              },
              child: Text("Assistir",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  )));
          return AlertDialog(
            content: Text('Para continuar assista a um anúncio, por favor...'),
            actions: [buttonAssistir],
          );
        });
  }

  String pegarDiferenca() {
    Timestamp ultimaVida = UserModel.of(context).userData['dataUltimaVida'];
    DateTime date = ultimaVida.toDate();
    return date.difference(Timestamp.now().toDate()).toString();
  }

  respostaVerdadeira() {
    quizController.hitNumber++;
    quizController.somaPontos();

    UserModel.of(context).userData['acertosCategorias']
        [quizController.categoria] = UserModel.of(context)
            .userData['acertosCategorias'][quizController.categoria] +
        1;
    if (UserModel.of(context).userData['pontosDiarios'] >= 200) {
      UserModel.of(context).userData['acertos'] =
          UserModel.of(context).userData['acertos'] + quizController.hitNumber;
      UserModel.of(context).userData['pontos'] =
          UserModel.of(context).userData['pontos'] + quizController.getPontos();
      alertaLimiteQuiz();
    } else {
      if (quizController.maisQuestoes()) {
        tocavel = [true, true, true, true, true];
        quizController.getProximaQuestao();
        cancelTimer = false;
        timer = 90;
        showTimer = '90';
        startTimer(Duration(seconds: 1));
      } else {
        UserModel.of(context).userData['pontos'] =
            UserModel.of(context).userData['pontos'] +
                quizController.getPontos();
        UserModel.of(context).userData['acertos'] =
            UserModel.of(context).userData['acertos'] +
                quizController.hitNumber;
        UserModel.of(context).userData['pontosDiariosData'] = Timestamp.now();
        UserModel.of(context).updateUserLocal();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AcabouScreen()));
      }
    }
  }

  analisaErro() {
    if (quizController.getPontos() > 0.0) {
      UserModel.of(context).userData['acertos'] =
          UserModel.of(context).userData['acertos'] + quizController.hitNumber;
      UserModel.of(context).userData['pontos'] =
          UserModel.of(context).userData['pontos'] + quizController.getPontos();
      UserModel.of(context).userData['pontosDiariosData'] = Timestamp.now();
      UserModel.of(context).updateUserLocal();
    }
    if (UserModel.of(context).userData['vidasExtra'] > 0) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ErrouScreen(
              quizController, categoria, "Ops, resposta errada :(")));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SemVidasExtraScreen()));
    }
  }

  @override
  void onUnityAdsFinish(String placementId, FinishState result) {
    if (estadoPerguntas) {
      estadoPerguntas = false;
      if (acertou) {
        respostaVerdadeira();
      } else {
        if (chanceTentarNovamente > 0 ||
            UserModel.of(context).userData['moedas'] >= 10) {
          alertaComChance();
        } else {
          analisaErro();
        }
      }
    } else {
      if (opcaoAjuda == "eliminar") {
        elimarRespostas();
      } else if (opcaoAjuda == "tentar") {
        tentarNovamenteAjuda();
      } else if (opcaoAjuda == "pular") {
        pularQuestao();
      }
    }
  }

  @override
  void onUnityAdsError(UnityAdsError error, String message) {
    showColoredToast('Ops, algo deu errado, tente novamente...');
    if (estadoPerguntas) {
      estadoPerguntas = false;
      if (acertou) {
        respostaVerdadeira();
      } else {
        if (chanceTentarNovamente > 0 ||
            UserModel.of(context).userData['moedas'] >= 10) {
          alertaComChance();
        } else {
          analisaErro();
        }
      }
    } else {
      if (opcaoAjuda == "eliminar") {
        startTimer(Duration(seconds: 1));
      } else if (opcaoAjuda == "tentar") {
        analisaErro();
      } else if (opcaoAjuda == "pular") {
        startTimer(Duration(seconds: 1));
      }
    }
  }

  @override
  void onUnityAdsReady(String placementId) {
    if (videoPlacementId.contains(placementId)) {
      setState(() {
        _iniciado = true;
        _ready = true;
      });
    }
  }

  @override
  void onUnityAdsStart(String placementId) {
    showColoredToast("Um anúncio está sendo carregado, aguarde!");
    if (videoPlacementId.contains(placementId)) {
      setState(() {
        _iniciado = false;
        _ready = false;
      });
    }
  }
}
