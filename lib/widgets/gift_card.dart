import 'package:flutter/material.dart';
import 'package:quiz_cash/screens/premio_screen.dart';

class GiftCard extends StatefulWidget {
  final String image;
  final double valorSaque;
  final double pontos;
  final String nomePremio;

  GiftCard(this.image, this.valorSaque, this.pontos, this.nomePremio);

  @override
  _GiftCardState createState() =>
      _GiftCardState(image, valorSaque, pontos, nomePremio);
}

class _GiftCardState extends State<GiftCard> {
  final String image;
  final double valorSaque;
  final double pontos;
  final String nomePremio;

  _GiftCardState(this.image, this.valorSaque, this.pontos, this.nomePremio);

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
  );*/

  //InterstitialAd _interstitialAd;

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

  /*displayVideo() {
    _interstitialAd?.dispose();
    _interstitialAd = createInterstitialAd()..load();
    _interstitialAd.show();
  }*/

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Column(
          children: <Widget>[
            Image.asset(
              image,
              height: 100.0,
              width: 180.0,
            ),
            Expanded(
              child: Text(
                "Saque R\$${valorSaque.toStringAsFixed(2)}",
                style: TextStyle(color: Colors.amber),
              ),
            )
          ],
        ),
      ),
      onTap: () async {
        //await displayVideo();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PremioScreen(
                pontos >= valorSaque, image, valorSaque, nomePremio, pontos)));
      },
    );
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
}
