import 'dart:ui';

import 'package:applovin/applovin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:quiz_cash/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_cash/model/user_model.dart';
import 'package:quiz_cash/screens/categorias_quiz_screen.dart';
import 'package:quiz_cash/screens/esperar_vidas.dart';
import 'package:quiz_cash/widgets/top_container.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:url_launcher/url_launcher.dart';

/*const String videoPlacementId = 'moedas';
const String gameIdAndroid = '3714065';
const String gameIdIOS = '3714064';*/
const url =
    "https://play.google.com/store/apps/details?id=br.com.mouracode.quiz_cash";

class OpcoesTab extends StatefulWidget {
  @override
  _OpcoesTabState createState() => _OpcoesTabState();
}

class _OpcoesTabState extends State<OpcoesTab> {
  //with UnityAdsListener {
  double _pontos = 0.1;
  int _moedas = 0;
  String _saudacao = "Bem vindo!!";
  bool _ready;
  bool _iniciado = false;
  String versaoAtual = '';
  String versaoMaisRecente = '';
  bool disponivel = true;

  @override
  void initState() {
    AppLovin.init();
    super.initState();
    //UnityAdsFlutter.initialize(gameIdAndroid, gameIdIOS, this, false);
    //_bannerAd = createBannerAd()..load();
    //displayBanner();
    getInformacoes();
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
      somaPontos();
    }
  }

  getInformacoes() async {
    disponivel = await Firestore.instance
        .collection('informacoes')
        .document('disponivel')
        .get()
        .then((value) => value.data['disponivel']);
    versaoMaisRecente = await Firestore.instance
        .collection('informacoes')
        .document('versaoatual')
        .get()
        .then((value) => value.data['versao']);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versaoAtual = packageInfo.version;
    if (versaoAtual != versaoMaisRecente) {
      alertaVersaoDiferente();
    }
  }

  @override
  /*void onUnityAdsError(UnityAdsError error, String message) {
    AppLovin.requestInterstitial(
        (AppLovinAdListener event) => listener(event, true),
        interstitial: true);
  }

  @override
  void onUnityAdsFinish(String placementId, FinishState result) {
    if (result == FinishState.completed || result == FinishState.skipped) {
      somaPontos();
    }
  }*/

  void somaPontos() {
    UserModel.of(context).userData['moedas'] =
        50 + UserModel.of(context).userData['moedas'];

    int a = UserModel.of(context).userData['assistirVideo'];
    a--;
    UserModel.of(context).userData['assistirVideo'] = a;
    UserModel.of(context).userData['assistirVideoData'] = Timestamp.now();
    UserModel.of(context).updateUserLocal();
    alertaPontos();
  }

  void showColoredToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Theme.of(context).primaryColor,
      textColor: Colors.white,
    );
  }

  alertaAviso() {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
        var buttonOk = FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "ok",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ));
        return AlertDialog(
          title: Text("Aviso!!"),
          content: Text(
              "O google retirou a monetização do nosso aplicativo, então enquanto corremos atrás da retomada dos anuncios, algumas funcionalidades não estão dísponiveis, mas retornaram em breve! Pedimos desculpa pelo contratempo, mas você ainda pode continuar a jogar o quiz e ganhar enquanto isso!"),
          actions: [buttonOk],
        );
      },
    );
  }

  alertaPontos() {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          var buttonOk = FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "ok",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ));

          return AlertDialog(
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Center(
                child: Icon(
                  Icons.monetization_on,
                  color: Colors.amber,
                  size: 40.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  "Oba, você conseguiu mais ${50} moedas e agora tem $_moedas!!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18.0),
                ),
              )
            ]),
            actions: [buttonOk],
          );
        },
      );
    }
  }

  alertaIndisponivel() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        var buttonOk = FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "ok",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ));

        return AlertDialog(
          content: Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              "Ops estamos passando por uma atualização no sistema, tente novamente em minutos...",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 18.0),
            ),
          ),
          actions: [buttonOk],
        );
      },
    );
  }

  alertaLimiteQuiz() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        var buttonOk = FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "ok",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ));

        return AlertDialog(
          content: Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              "Ops você atingiu seu limite diario de pontos...",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 18.0),
            ),
          ),
          actions: [buttonOk],
        );
      },
    );
  }

  alertaVersaoDiferente() {
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          var buttonOk = FlatButton(
              onPressed: () {
                if (canLaunch(url) != null)
                  launch(url);
                else {
                  showColoredToast(
                      "Ops, parece que um erro ocorreu, tente novamente em segundos!");
                }
              },
              child: Text(
                "Atualizar",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ));

          return AlertDialog(
            content: Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                "A uma nova versao disponivel, atualize o aplicativo para continuar usando...",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18.0),
              ),
            ),
            actions: [buttonOk],
          );
        },
      );
    }
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

  displayBanner(){
    _bannerAd ??= createBannerAd();
    _bannerAd
      ..load()
      ..show();
  }*/

  @override
  void dispose() {
    //_bannerAd?.dispose();
    //_interstitialAd?.dispose();
    super.dispose();
  }

  /*InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: "ca-app-pub-1841433718864307/4242563078",
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      if (model.isLoding) {
        return Center(child: CircularProgressIndicator());
      } else {
        _pontos = model.getPontos();
        _moedas = model.getMoedas();
        _saudacao =
            "Olá, ${model.isLoggedIn() ? model.userData['nome'] != null ? model.userData['nome'] : "Bem Vindo!!" : "Bem Vindo!!"}";

        return SafeArea(
            child: Column(
          children: [
            TopContainer(
              height: 140,
              width: width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            margin: const EdgeInsets.only(
                              right: 8.0,
                            ),
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
                            margin: const EdgeInsets.only(right: 8.0),
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
                                    "$_moedas",
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    _saudacao,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w800),
                                  )),
                              GestureDetector(
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 4.0),
                                    child: Text(
                                        model.isLoggedIn() ? "Sair" : "Entrar",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15))),
                                onTap: () {
                                  model.isLoggedIn()
                                      ? setState(() {
                                          model.signOut();
                                          _saudacao = "Bem vindo!!";
                                        })
                                      : Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ]),
            ),
            SizedBox(
              height: 20.0,
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
                        "Jogar Quiz",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ))),
                onTap: disponivel
                    ? () {
                        if (model.isLoggedIn() || model.isLoding) {
                          if (model.userData.containsKey('pontosDiarios')) {
                            if (!model.userData
                                .containsKey('pontosDiariosData')) {
                              model.userData['pontosDiariosData'] =
                                  Timestamp.now();
                            }

                            Timestamp date2 =
                                model.userData['pontosDiariosData'];
                            DateTime d = DateTime.now();
                            if (d.day != date2.toDate().day ||
                                d.month != date2.toDate().month) {
                              model.userData['pontosDiarios'] = 0;
                            }
                          } else {
                            model.userData['pontosDiarios'] = 0;
                            model.userData['pontosDiariosData'] =
                                Timestamp.now();
                          }
                          if (!model.userData
                              .containsKey('acertosCategorias')) {
                            model.userData['acertosCategorias'] = {
                              "ciencias": 0,
                              "entretenimento": 0,
                              "geografia": 0,
                              "historia": 0,
                              "literatura": 0,
                              "matematica": 0
                            };
                          }
                          if (model.userData.containsKey('pontosDiarios')) {
                            if (model.userData['pontosDiarios'] >= 200) {
                              alertaLimiteQuiz();
                            } else {
                              if (calculaSeTemVida(context)) {
                                if (UserModel.of(context).userData['vidas'] ==
                                    0) {
                                  UserModel.of(context).userData['vidas'] = 3;
                                  UserModel.of(context).updateUserLocal();
                                }
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CategoriasQuizScreen()));
                              } else {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => EsperarVidaScreen(
                                            pegarDiferenca(model))));
                              }
                            }
                          } else {
                            if (calculaSeTemVida(context)) {
                              if (UserModel.of(context).userData['vidas'] ==
                                  0) {
                                UserModel.of(context).userData['vidas'] = 3;
                                UserModel.of(context).updateUserLocal();
                              }
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CategoriasQuizScreen()));
                            } else {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => EsperarVidaScreen(
                                          pegarDiferenca(model))));
                            }
                          }
                        } else {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CategoriasQuizScreen()));
                        }
                      }
                    : alertaIndisponivel),
            GestureDetector(
                child: SizedBox(
                    height: 60.0,
                    width: 320.0,
                    child: Card(
                        //color: Colors.grey[100],
                        child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "Ganhar Moedas",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ))),
                onTap: () async {
                  if (model.isLoggedIn()) {
                    if (model.userData.containsKey('assistirVideo')) {
                      if (model.userData['assistirVideo'] < 20) {
                        Timestamp date = model.userData['assistirVideoData'];
                        DateTime d = DateTime.now();
                        if (d.day != date.toDate().day ||
                            d.month != date.toDate().month) {
                          model.userData['assistirVideo'] = 20;
                          Timestamp vida = UserModel.of(context)
                              .userData['tentarNovamenteData'];
                          if (d.day != vida.toDate().day ||
                              d.month != vida.toDate().month) {
                            model.userData['vidas'] = 3;
                          }
                        }
                      }
                    } else {
                      model.userData['assistirVideo'] = 20;
                    }
                    if (mounted) {
                      if (model.userData['assistirVideo'] > 1) {
                        showColoredToast(
                            "Um anúncio está sendo carregado, aguarde!");
                        AppLovin.requestInterstitial(
                            (AppLovinAdListener event) => listener(event, true),
                            interstitial: true);
                      } else {
                        if (model.userData['assistirVideo'] < 1) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              var buttonOk = FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "ok",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ));
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(Icons.sentiment_dissatisfied,
                                        color: Theme.of(context).primaryColor,
                                        size: 40),
                                    SizedBox(height: 16.0),
                                    Text(
                                        "Ops, você atingiu o limite de vídeos por dia!!"),
                                  ],
                                ),
                                actions: [buttonOk],
                              );
                            },
                          );
                        } else {
                          showColoredToast(
                              "Um anúncio está sendo carregado, aguarde!");
                          AppLovin.requestInterstitial(
                              (AppLovinAdListener event) =>
                                  listener(event, true),
                              interstitial: true);
                        }
                      }
                    } else {
                      showColoredToast(
                          "Ops, parece que um erro ocorreu, tente novamente em segundos!");
                    }
                  } else {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  }
                }),
          ],
        ));
      }
    });
  }

  calculaSeTemVida(context) {
    if (UserModel.of(context).isLoggedIn()) {
      if (UserModel.of(context).userData['pontosDiarios'] < 200) {
        if (UserModel.of(context).userData['vidas'] == 0) {
          DateTime d = DateTime.now();
          Timestamp ultimaVida =
              UserModel.of(context).userData['dataUltimaVida'];
          return d.isAfter(ultimaVida.toDate());
        } else {
          return true;
        }
      } else {
        return false;
      }
    }
  }

  String pegarDiferenca(UserModel model) {
    Timestamp ultimaVida = model.userData['dataUltimaVida'];

    return ultimaVida.toDate().difference(Timestamp.now().toDate()).toString();
  }

  /*@override
  void onUnityAdsReady(String placementId) {
    if (videoPlacementId == placementId) {
      setState(() {
        _ready = true;
        _iniciado = true;
      });
    }
  }

  @override
  void onUnityAdsStart(String placementId) {
    if (videoPlacementId == placementId) {
      setState(() {
        _ready = false;
        _iniciado = false;
      });
    }
  }*/
}
