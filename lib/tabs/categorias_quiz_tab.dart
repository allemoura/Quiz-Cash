import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_cash/tiles/categoria_tile.dart';

class CategoriasQuizTab extends StatefulWidget {
  @override
  _CategoriasQuizTabState createState() => _CategoriasQuizTabState();
}

class _CategoriasQuizTabState extends State<CategoriasQuizTab>
    with AutomaticKeepAliveClientMixin {
  List categorias = List();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("categorias").getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return GridView.builder(
            padding: EdgeInsets.all(4.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 3.0,
              childAspectRatio: 0.96,
            ),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, int index) {
              categorias = snapshot.data.documents.map((doc) => doc).toList();
              return CategoriaTile(categorias[index]);
            },
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
