import 'package:flutter/material.dart';

class MenuSarapanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Sarapan"),
      ),
      body: Center(
        child: Text(
          "Daftar Menu Sarapan",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
