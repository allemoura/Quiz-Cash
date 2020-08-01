import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_cash/model/user_model.dart';
import 'package:quiz_cash/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        return MaterialApp(
          theme: ThemeData(
              primarySwatch: Colors.blue, primaryColor: Colors.redAccent[200]),
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        );
      }),
    );
  }
}
