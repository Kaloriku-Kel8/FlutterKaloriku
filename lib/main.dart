import 'package:flutter/material.dart';
import 'package:kaloriku/screens/login.dart';

void main() {
  runApp(const KaloriKu());
}

class KaloriKu extends StatelessWidget {

  const KaloriKu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test Login',
      theme: ThemeData(
        primarySwatch: Colors.blue, 
      ),
      home: LoginScreen(),
    ); 
  }
}