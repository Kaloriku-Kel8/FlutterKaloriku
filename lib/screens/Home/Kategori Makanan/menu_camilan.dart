import 'package:flutter/material.dart';

class MenuCamilanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Camilan"),
      ),
      body: Center(
        child: Text(
          "Daftar Menu Camilan",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
