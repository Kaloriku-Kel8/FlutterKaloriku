import 'package:flutter/material.dart';
import 'package:kaloriku/screens/home.dart';
import 'package:kaloriku/screens/login.dart';
import 'package:kaloriku/screens/register.dart';
import 'package:kaloriku/screens/userdatainput.dart';
import 'package:kaloriku/statemanag.dart';


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
  home:  RegisterScreen(),
  debugShowCheckedModeBanner: false,
    ); 
  }
}