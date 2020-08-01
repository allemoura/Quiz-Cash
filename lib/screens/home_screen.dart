import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quiz_cash/tabs/gifts_card_tab.dart';
import 'package:quiz_cash/tabs/informacoes_conta.dart';
import 'package:quiz_cash/tabs/opcoes_tab.dart';
import 'package:quiz_cash/tabs/ranking_tab.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _page = 0;
  bool _connection = false;
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateStatus);
    _pageController = PageController();
  }

  void _updateStatus(ConnectivityResult connectivityResult) async {
    if (connectivityResult != ConnectivityResult.none) {
      updateConected(true);
    } else {
      updateConected(false);
    }
  }

  void updateConected(bool conected) {
    setState(() {
      _connection = conected;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Theme.of(context).primaryColor,
            primaryColor: Colors.white,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: TextStyle(color: Colors.white54))),
        child: BottomNavigationBar(
            currentIndex: _page,
            onTap: (p) {
              _pageController.animateToPage(p,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.gamepad), title: Text("Jogos")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.monetization_on), title: Text("Sacar")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.equalizer), title: Text("Ranking")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), title: Text("Minha Conta")),
            ]),
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (p) {
            setState(() {
              _page = p;
            });
          },
          children: <Widget>[
            _connection ? OpcoesTab() : semConexao(),
            _connection ? GiftsCardTab() : semConexao(),
            _connection ? RankingTab() : semConexao(),
            _connection ? InformacoesTab() : semConexao(),
          ],
        ),
      ),
    );
  }

  Widget semConexao() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.signal_wifi_off,
            size: 80.0,
            color: Colors.redAccent,
          ),
          Text(
            "Ops, não há conecxão disponível...",
            style: TextStyle(fontSize: 20, color: Colors.grey[800]),
          )
        ],
      ),
    );
  }

  onUpdate(int selected) {
    print(selected);
  }
}
