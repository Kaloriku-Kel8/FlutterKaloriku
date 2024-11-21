import 'package:flutter/material.dart';



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,      
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Cari pertanyaan',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Tambahkan logika untuk tombol 'Buat'
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          QuestionCard(
            title: 'Menambah Berat Badan',
            content: 'Barangkali di sini ada yang sudah berhasil meningkatkan berat badan, boleh tahu tipsnya?',
            likes: 2,
            comments: 9,
            date: '23/09/2024',
          ),
          SizedBox(height: 16.0),
          QuestionCard(
            title: 'Manfaat Gula Bagi Tubuh',
            content: 'Ada yang pernah mengalami diabetes?',
            likes: 5,
            comments: 13,
            date: '14/09/2024',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Pertanyaan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final String title;
  final String content;
  final int likes;
  final int comments;
  final String date;

  const QuestionCard({
    super.key,
    required this.title,
    required this.content,
    required this.likes,
    required this.comments,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.thumb_up, size: 16),
                    const SizedBox(width: 4.0),
                    Text('$likes'),
                    const SizedBox(width: 16.0),
                    const Icon(Icons.comment, size: 16),
                    const SizedBox(width: 4.0),
                    Text('$comments'),
                  ],
                ),
                Text(date),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Tambahkan logika untuk tombol 'Lihat'
                },
                child: const Text('Lihat'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
