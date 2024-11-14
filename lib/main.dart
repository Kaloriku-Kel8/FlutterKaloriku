import 'package:flutter/material.dart';
import 'package:kaloriku/screens/home.dart';
import 'package:kaloriku/screens/userInput1.dart';
import 'package:kaloriku/screens/userInput2.dart';
import 'package:kaloriku/screens/userInput3.dart';
import 'package:kaloriku/screens/userInput4.dart';
import 'package:kaloriku/screens/register.dart';
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
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
