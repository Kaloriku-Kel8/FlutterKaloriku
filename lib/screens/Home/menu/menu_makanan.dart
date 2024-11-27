import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FoodDetailScreen(),
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'Roboto',
            ),
      ),
      routes: {
        '/home': (context) => const HomeMenuScreen(), // You need to define HomeMenuScreen or remove this route.
      },
    );
  }
}

class FoodDetailScreen extends StatefulWidget {
  const FoodDetailScreen({Key? key}) : super(key: key);

  @override
  _FoodDetailScreenState createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FluentIcons.arrow_left_12_filled),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Detail Makanan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image of the food
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/sate.jpg', // Add your image in assets folder
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 16),
            // Description of the food
            const Text(
              'Sate ayam dengan saus kacang, nasi, dan irisan timun.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('756 Cal'),
            const SizedBox(height: 16),
            // Recipe details
            const Text(
              'Resepnya balblalablabla',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const Spacer(),
            // Add button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Action when the button is clicked
                },
                child: const Text('Tambah'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  minimumSize: const Size(150, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy HomeMenuScreen definition (you can replace this with your actual screen definition)
class HomeMenuScreen extends StatelessWidget {
  const HomeMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Menu')),
      body: const Center(child: Text('Welcome to the Home Menu')),
    );
  }
}
