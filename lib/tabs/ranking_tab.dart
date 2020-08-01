import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_cash/tiles/ranking_tile.dart';
import 'package:quiz_cash/widgets/top_container.dart';

class RankingTab extends StatefulWidget {
  @override
  _RankingTabState createState() => _RankingTabState();
}

class _RankingTabState extends State<RankingTab>
    with AutomaticKeepAliveClientMixin {
  List categorias = List();
  List jogador1 = ['', 0.0];
  List jogador2 = ['', 0.0];
  List jogador3 = ['', 0.0];
  int cont;
  int posJogador1;
  int posJogador2;
  int posJogador3;
  List pos = [false, false, false];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width;
    cont = 1;
    return Stack(children: <Widget>[
      TopContainer(
        height: 140,
        width: width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: CircleAvatar(
                      maxRadius: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            jogador2[0],
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Theme.of(context).primaryColor,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'R\$${jogador2[1].toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.amber,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: CircleAvatar(
                      maxRadius: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            jogador1[0],
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Theme.of(context).primaryColor,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'R\$${jogador1[1].toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.amber,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: CircleAvatar(
                      maxRadius: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            jogador3[0],
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Theme.of(context).primaryColor,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'R\$${jogador3[1].toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.amber,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              )
            ]),
      ),
      Container(
          margin: EdgeInsets.only(top: 150.0),
          child: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance
                .collection("users")
                .orderBy("pontos")
                .getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                posJogador1 = snapshot.data.documents.length;
                posJogador2 = snapshot.data.documents.length - 1;
                posJogador3 = snapshot.data.documents.length - 2;

                var dividedTiles = ListTile.divideTiles(
                        tiles: snapshot.data.documents
                            .map((doc) {
                              if (cont == posJogador1) {
                                addPos(doc);

                                cont = 1;

                                return Container();
                              } else if (cont == posJogador2) {
                                addPos(doc);

                                if (cont < snapshot.data.documents.length) {
                                  cont++;
                                }
                                return Container();
                              } else if (cont == posJogador3) {
                                addPos(doc);
                                if (cont < snapshot.data.documents.length) {
                                  cont++;
                                }

                                return Container();
                              } else {
                                cont++;
                                return RankingTile(doc);
                              }
                            })
                            .toList()
                            .reversed,
                        color: Colors.grey[500])
                    .toList();
                return ListView(
                  children: dividedTiles,
                );
              }
            },
          ))
    ]);
  }

  addPos(DocumentSnapshot doc) {
    if (cont == posJogador1) {
      jogador1 = [doc.data['nome'], doc.data['pontos']];
      pos[0] = true;
    } else if (cont == posJogador2) {
      jogador2 = [doc.data['nome'], doc.data['pontos']];
      pos[1] = true;
    } else if (cont == posJogador3) {
      jogador3 = [doc.data['nome'], doc.data['pontos']];
      pos[1] = true;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
