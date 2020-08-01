import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_cash/model/user_model.dart';
import 'package:quiz_cash/screens/categorias_quiz_screen.dart';
import 'package:quiz_cash/screens/esperar_vidas.dart';
import 'package:splashscreen/splashscreen.dart';

class AcabouScreen extends StatefulWidget {
  @override
  _AcabouScreenState createState() => _AcabouScreenState();
}

class _AcabouScreenState extends State<AcabouScreen> {
  String date;

  String pegarDiferenca() {
    Timestamp ultimaVida = UserModel.of(context).userData['dataUltimaVida'];

    return ultimaVida.toDate().difference(Timestamp.now().toDate()).toString();
  }

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).userData['vidas'] == 0) {
      date = pegarDiferenca();
      print(date);
    }
    return Stack(children: <Widget>[
      SplashScreen(
          seconds: 2,
          gradientBackground: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xff80d8c8), Color(0xff80d8c8)]),
          navigateAfterSeconds:
              date == null ? CategoriasQuizScreen() : EsperarVidaScreen(date),
          loaderColor: Colors.transparent),
      Container(
          decoration: BoxDecoration(
              image: DecorationImage(
        image: AssetImage("images/acertou.png"),
        fit: BoxFit.contain,
      )))
    ]);
  }
}
