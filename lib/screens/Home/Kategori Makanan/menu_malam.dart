import 'package:flutter/material.dart';

class MenuMalamScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Malam"),
      ),
      body: Center(
        child: Text(
          "Daftar Menu Malam",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
