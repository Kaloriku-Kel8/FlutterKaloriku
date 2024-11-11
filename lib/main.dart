import 'package:flutter/material.dart';
import 'package:kaloriku/screens/home.dart';
import 'package:kaloriku/screens/userdatainput.dart';
import 'package:kaloriku/screens/userdatainput2.dart';
import 'package:kaloriku/screens/userdatainput3.dart';
import 'package:kaloriku/screens/userdatainput4.dart';


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