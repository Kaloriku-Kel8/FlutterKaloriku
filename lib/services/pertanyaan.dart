import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
    home: QuestionPage(),
    ),
  );
}


class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final List<Map<String, dynamic>> questions = [
    {
      'title': 'Menambah Berat Badan',
      'content': 'Barangkali di sini ada yang sudah berhasil meningkatkan berat badan, boleh tahu tipsnya?',
      'likes': 2,
      'comments': 9,
      'date': '23/09/2024'
    },
    {
      'title': 'Manfaat Gula Bagi Tubuh',
      'content': 'Ada yang pernah mengalami diabetes?',
      'likes': 5,
      'comments': 13,
      'date': '14/09/2024'
    },
  ];

  void _addNewQuestion(String title, String content) {
    setState(() {
      questions.insert(0, {
        'title': title,
        'content': content,
        'likes': 0,
        'comments': 0,
        'date': DateTime.now().toString().split(' ')[0],
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pertanyaan'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddQuestionDialog();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(question['content']),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.thumb_up, size: 16),
                          SizedBox(width: 4),
                          Text('${question['likes']}'),
                          SizedBox(width: 16),
                          Icon(Icons.comment, size: 16),
                          SizedBox(width: 4),
                          Text('${question['comments']}'),
                        ],
                      ),
                      Text(
                        question['date'],
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      TextButton(
                        onPressed: () {
                          // Tambahkan logika untuk melihat detail pertanyaan
                        },
                        child: Text('Lihat', style: TextStyle(color: Colors.green)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddQuestionDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Buat Pertanyaan Baru'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Judul'),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Konten'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text;
                final content = contentController.text;
                if (title.isNotEmpty && content.isNotEmpty) {
                  _addNewQuestion(title, content);
                }
                Navigator.of(context).pop();
              },
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }
}
