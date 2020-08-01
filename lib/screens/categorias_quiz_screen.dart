import 'package:flutter/material.dart';
import 'package:quiz_cash/screens/home_screen.dart';
import 'package:quiz_cash/tabs/categorias_quiz_tab.dart';

class CategoriasQuizScreen extends StatefulWidget {
  @override
  _CategoriasQuizScreenState createState() => _CategoriasQuizScreenState();
}

class _CategoriasQuizScreenState extends State<CategoriasQuizScreen> {
  /*static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>[
      'dinheiro',
      'cash',
      'donheiro online',
      'cash online',
      'dinheiro em casa'
    ],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    nonPersonalizedAds: false,
  );

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  */
  /*BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.leaderboard,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: "ca-app-pub-1841433718864307/4242563078",
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }*/

  initState() {
    super.initState();
    /*FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-1841433718864307~6944199297");
    _bannerAd = createBannerAd()..load();*/
  }

  @override
  void dispose() {
    //_bannerAd?.dispose();
    //_interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Categorias Quiz",
          style: TextStyle(
            color: Colors.amber[300],
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        actions: [
          FlatButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      //displayVideo();
                      var buttomSair = FlatButton(
                          padding: EdgeInsets.only(right: 100.0),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
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
                            //_bannerAd?.dispose();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Cancelar",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.0),
                          ));
                      return AlertDialog(
                        title: Text("Sair das Caterogias"),
                        content: Text("Tem certeza disso?"),
                        actions: [buttomSair, buttomCancelar],
                      );
                    });
              },
              child: Container(
                  margin: EdgeInsets.only(left: 50.0),
                  child: Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 30.0,
                  )))
        ],
      ),
      body: CategoriasQuizTab(),
    );
  }

  /*displayBanner(){
    _bannerAd ??= createBannerAd();
    _bannerAd
      ..load()
      ..show();
  }

  displayVideo() {
    _interstitialAd?.dispose();
    _interstitialAd = createInterstitialAd()..load();
    _interstitialAd.show();
  }*/
}
