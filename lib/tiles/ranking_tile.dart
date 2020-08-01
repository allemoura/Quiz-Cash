import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RankingTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  const RankingTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    double pontos = snapshot.data['pontos'] + 0.0;
    return Row(
      //crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Center(
            child: Padding(
          padding: EdgeInsets.only(left: 6.0),
          child: Icon(
            Icons.account_circle,
            size: 50,
            color: Colors.grey[300],
          ),
        )),
        Center(
            child: SizedBox(
                height: 80.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(30.0, 30.0, 0.0, 2.0),
                      child: Text(
                        snapshot.data["nome"],
                        maxLines: 1,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(30.0, 4.0, 0.0, 4.0),
                        child: Text(
                          "Pontos - R\$${pontos.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Colors.amber[300],
                            fontSize: 15.0,
                            fontStyle: FontStyle.italic,
                          ),
                        )),
                  ],
                )))
      ],
    );
  }
}
