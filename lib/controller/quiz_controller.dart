import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_cash/data/questoes_model.dart';

class QuizController {
  List<QuestaoData> questoes = List();
  int questionIndex;
  int hitNumber;
  List<String> acertos = List();
  bool inicio = true;
  double _pontos;

  final String categoria;

  QuizController(this.categoria);

  int getQuantidadeDeQuestoes() => questoes.length;

  Future<void> inicializar() async {
    _pontos = 0.0;
    hitNumber = 0;
    QuestaoData questaoData;
    print(await Firestore.instance
        .collection("categorias")
        .document(categoria)
        .collection("perguntas")
        .getDocuments()
        .then((value) => value.documents.map((e) {
              questaoData = QuestaoData.fromDocument(e);
              questoes.add(questaoData);
            })));
    questionIndex = Random().nextInt(50);
  }

  double getPontos() {
    return _pontos;
  }

  void somaPontos() {
    _pontos += 0.001;
  }

  bool maisQuestoes() {
    return acertos.length != getQuantidadeDeQuestoes();
  }

  void resetPontos() {
    _pontos = 0.0;
  }

  getProximaQuestao() {
    questionIndex = Random().nextInt(getQuantidadeDeQuestoes());
  }

  String getResposta1() => questoes[questionIndex].respostas["resposta1"];

  String getResposta2() => questoes[questionIndex].respostas["resposta2"];

  String getResposta3() => questoes[questionIndex].respostas["resposta3"];

  String getResposta4() => questoes[questionIndex].respostas["resposta4"];

  String getResposta5() => questoes[questionIndex].respostas["resposta5"];

  bool getRespostaCorreta(String respostaUsuario) {
    if (respostaUsuario.trim().toUpperCase() ==
        questoes[questionIndex].resposta.trim().toUpperCase()) {
      addAcertou();
      return true;
    } else {
      return false;
    }
  }

  void addAcertou() {
    if (!acertos.contains(getQuestao())) {
      acertos.add(getQuestao());
    }
  }

  String getQuestao() => questoes[questionIndex].questao;

  int getPosRespostaCorreta() {
    if (getRespostaCorreta(getResposta1())) {
      return 0;
    } else if (getRespostaCorreta(getResposta2())) {
      return 1;
    } else if (getRespostaCorreta(getResposta3())) {
      return 2;
    } else if (getRespostaCorreta(getResposta4())) {
      return 3;
    } else {
      return 4;
    }
  }
}
