import 'package:flutter/material.dart';
import 'package:quiz_cash/tabs/historico_saques_tab.dart';

class HistoricoSaqueScreen extends StatefulWidget {
  @override
  _HistoricoSaqueScreenState createState() => _HistoricoSaqueScreenState();
}

class _HistoricoSaqueScreenState extends State<HistoricoSaqueScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Historico de Saque"),
          centerTitle: true,
        ),
        body: HistoricoSaquesTab());
  }
}
