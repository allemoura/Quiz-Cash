import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoricoSaqueTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  HistoricoSaqueTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    int status = snapshot.data["status"];
    return Card(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Código do saque: ${snapshot.documentID}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(_buildProductsText()),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  "Status Saque:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: _buildCircle("1", "Processando Saque", status, 1),
                    ),
                    Container(
                      height: 1.0,
                      width: 40.0,
                      color: Colors.grey[500],
                    ),
                    Expanded(child: _buildCircle("2", "Processado", status, 2)),
                    Container(
                      height: 1.0,
                      width: 40.0,
                      color: Colors.grey[500],
                    ),
                    Expanded(child: _buildCircle("3", "Finalizado", status, 3))
                  ],
                )
              ],
            )));
  }

  String _buildProductsText() {
    Timestamp data = snapshot.data['data'];
    String text = "Descrição:\n";
    text += "Premio: ${snapshot.data['nome']}\n";
    text += "Valor: R\$ ${snapshot.data["valor"].toStringAsFixed(2)}\n";
    text += "Data: ${data.toDate().toLocal().day}/${data.toDate().toLocal().month}/${data.toDate().toLocal().year} ás ${data.toDate().toLocal().hour}:${data.toDate().toLocal().minute}";
    if (snapshot.data['status'] == 4) {
      Timestamp dataProcessado = snapshot.data['processado'];
      text += "\nData Finalizado: ${dataProcessado.toDate().toLocal().day}/${dataProcessado.toDate().toLocal().month}/${dataProcessado.toDate().toLocal().year} ás ${dataProcessado.toDate().toLocal().hour}:${dataProcessado.toDate().toLocal().minute}";
    }

    return text;
  }

  Widget _buildCircle(
      String title, String subtitle, int status, int thisStatus) {
    Color backColor;
    Widget child;

    if (status < thisStatus) {
      backColor = Colors.grey[500];
      child = Text(
        title,
        style: TextStyle(color: Colors.white),
      );
    } else if (status == thisStatus) {
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.end,
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(
        Icons.check,
        color: Colors.white,
      );
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
