import 'package:flutter/material.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: ThemeSwitcherScreen(
        isDarkTheme: isDarkTheme,
        onThemeChanged: (value) {
          setState(() {
            isDarkTheme = value;
          });
        },
      ),
    );
  }
}

class ThemeSwitcherScreen extends StatelessWidget {
  final bool isDarkTheme;
  final ValueChanged<bool> onThemeChanged;

  const ThemeSwitcherScreen({super.key, 
    required this.isDarkTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tema Gelap/Terang'),
        actions: [
          Switch(
            value: isDarkTheme,
            onChanged: onThemeChanged,
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Aktifkan tema gelap/terang dengan switch di AppBar!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
