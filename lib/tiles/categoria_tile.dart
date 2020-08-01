import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_cash/controller/quiz_controller.dart';
import 'package:quiz_cash/model/user_model.dart';
import 'package:quiz_cash/screens/login_screen.dart';
import 'package:quiz_cash/screens/quiz_screen.dart';
import 'package:quiz_cash/widgets/vidas_wiget.dart';

class CategoriaTile extends StatefulWidget {
  final DocumentSnapshot snapshot;

  CategoriaTile(this.snapshot);

  @override
  _CategoriaTileState createState() => _CategoriaTileState(snapshot);
}

class _CategoriaTileState extends State<CategoriaTile> {
  final DocumentSnapshot snapshot;

  _CategoriaTileState(this.snapshot);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Card(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
              Expanded(
                child: Image.network(
                  snapshot["icone"],
                  height: 90.0,
                  width: 90.0,
                ),
              ),
              Text(
                snapshot["titulo"],
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 16.0),
            ])),
        onTap: () async {
          if (!UserModel.of(context).isLoggedIn()) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => LoginScreen()));
          } else {
            if (UserModel.of(context).userData['vidas'] > 0) {
              UserModel.of(context).userData['vidas'] =
                  UserModel.of(context).userData['vidas'] - 1;
              if (UserModel.of(context).userData['vidas'] == 0) {
                Timestamp now = Timestamp.now();
                UserModel.of(context).userData['dataUltimaVida'] =
                    Timestamp.fromMillisecondsSinceEpoch(
                        now.millisecondsSinceEpoch + 10800000);
              }
              if (UserModel.of(context).userData['vidasExtra'] < 3) {
                UserModel.of(context).userData['vidasExtra'] = 3;
              }

              await UserModel.of(context).updateUserLocal();

              await showDialog(
                context: context,
                builder: (context) {
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.of(context).pop();
                  });
                  return AlertDialog(
                    title: Text("Lembre-se das suas vidas..."),
                    content: VidasWidget(
                        UserModel.of(context).userData['vidas'] + 1),
                  );
                },
              );

              iniciaQuiz();
            }
          }
        });
  }

  iniciaQuiz() async {
    QuizController quizController = QuizController(snapshot.documentID);
    await quizController.inicializar();
    setState(() {});

    if (quizController.getQuantidadeDeQuestoes() > 0) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              QuizScreen(snapshot.data["titulo"], quizController)));
    } else {
      Center(child: CircularProgressIndicator());
    }
  }
}
