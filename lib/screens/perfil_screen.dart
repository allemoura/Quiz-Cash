import 'package:flutter/material.dart';
import 'package:quiz_cash/tabs/perfil_tab.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Meu Perfil"),
          centerTitle: true,
        ),
        body: PerfilTab());
  }
}
