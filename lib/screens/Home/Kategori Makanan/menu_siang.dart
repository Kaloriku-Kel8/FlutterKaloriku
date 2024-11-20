import 'package:flutter/material.dart';

class MenuSiangScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Siang"),
      ),
      body: Center(
        child: Text(
          "Daftar Menu Siang",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
