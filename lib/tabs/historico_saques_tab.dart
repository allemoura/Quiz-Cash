import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_cash/model/user_model.dart';
import 'package:quiz_cash/tiles/historico_saque_tile.dart';

class HistoricoSaquesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser.uid;
      return FutureBuilder<QuerySnapshot>(
          future: Firestore.instance
              .collection("users")
              .document(uid)
              .collection("saques")
              .orderBy('status')
              .getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              var listTile = ListTile.divideTiles(
                      tiles: snapshot.data.documents.map((doc) {
                        return HistoricoSaqueTile(doc);
                      }).toList(),
                      color: Colors.white)
                  .toList();
              return ListView(
                children: listTile,
              );
            }
          });
    } else {
      return Container();
    }
  }
}
