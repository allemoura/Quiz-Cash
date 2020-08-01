import 'package:cloud_firestore/cloud_firestore.dart';

class QuestaoData {
  String questao;
  Map respostas;
  String resposta;

  QuestaoData.fromDocument(DocumentSnapshot snapshot) {
    questao = snapshot.data["pergunta"];
    respostas = snapshot.data["respostas"];
    resposta = snapshot.data["resposta"];
  }
}
