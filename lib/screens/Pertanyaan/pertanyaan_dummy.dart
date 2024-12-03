import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFE8F5E9),
          hintStyle: TextStyle(color: Color(0xFF000000)),
          labelStyle: TextStyle(color: Color(0xFF000000)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightGreen, width: 1),
            borderRadius: BorderRadius.circular(15.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF61CA3D), width: 2),
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
      home: ForumPage(),
    );
  }
}

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  // Dummy data for forum questions and answers
  List<Map<String, dynamic>> forumItems = [
    {
      'question': 'Apa itu Flutter?',
      'author': 'User123',
      'date': '2024-12-01',
      'likes': 5,
      'answers': [
        {
          'author': 'DevMaster',
          'content': 'Flutter adalah framework open-source untuk membuat aplikasi mobile, web, dan desktop.',
          'likes': 2,
        },
        {
          'author': 'CodeFan',
          'content': 'Flutter sangat cepat dan fleksibel, cocok untuk aplikasi yang membutuhkan performance tinggi.',
          'likes': 3,
        },
      ],
    },
    {
      'question': 'Bagaimana cara membuat stateful widget?',
      'author': 'FlutterFan',
      'date': '2024-11-30',
      'likes': 3,
      'answers': [
        {
          'author': 'FlutterExpert',
          'content': 'StatefulWidget digunakan ketika kita membutuhkan widget yang statusnya dapat berubah.',
          'likes': 1,
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum Pertanyaan'),
        backgroundColor: Color(0xFF61CA3D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Cari Pertanyaan...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF000000)),
                ),
              ),
            ),
            // Forum posts list (Headline)
            Expanded(
              child: ListView.builder(
                itemCount: forumItems.length,
                itemBuilder: (context, index) {
                  var item = forumItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Question headline
                          Text(
                            item['question']!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          // Author and date
                          Row(
                            children: [
                              Text(
                                'Oleh ${item['author']} - ${item['date']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Spacer(),
                              // Likes
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(FluentIcons.thumb_like_24_filled),
                                    onPressed: () {
                                      setState(() {
                                        item['likes']++;
                                      });
                                    },
                                  ),
                                  Text(item['likes'].toString()),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          // View answers button
                          TextButton(
                            onPressed: () {
                              _showThreadDialog(context, item['answers']);
                            },
                            child: Text('Lihat Balasan (${item['answers'].length})'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle post a new question action
          _showNewQuestionDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF61CA3D),
      ),
    );
  }

  // Dialog to show thread of answers for a question
  void _showThreadDialog(BuildContext context, List<dynamic> answers) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thread Balasan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var answer in answers) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(child: Text(answer['author'][0])),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(answer['author'], style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text(answer['content']),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(FluentIcons.thumb_like_24_filled),
                                  onPressed: () {
                                    setState(() {
                                      answer['likes']++;
                                    });
                                  },
                                ),
                                Text(answer['likes'].toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tutup'),
            ),
            TextButton(
              onPressed: () {
                // Handle new answer action here
                Navigator.pop(context);
                _showNewAnswerDialog(context);
              },
              child: Text('Balas Pertanyaan'),
            ),
          ],
        );
      },
    );
  }

  // Dialog for posting new question
  void _showNewQuestionDialog(BuildContext context) {
    TextEditingController questionController = TextEditingController();
    TextEditingController answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tanya Pertanyaan Baru'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: InputDecoration(
                  hintText: 'Masukkan pertanyaan...',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: answerController,
                decoration: InputDecoration(
                  hintText: 'Masukkan jawaban...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Add new question logic here
                Navigator.pop(context);
              },
              child: Text('Kirim'),
            ),
          ],
        );
      },
    );
  }

  // Dialog for posting new answer
  void _showNewAnswerDialog(BuildContext context) {
    TextEditingController answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Balas Pertanyaan'),
          content: TextField(
            controller: answerController,
            decoration: InputDecoration(
              hintText: 'Masukkan jawaban...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Handle submit answer logic here
                Navigator.pop(context);
              },
              child: Text('Kirim'),
            ),
          ],
        );
      },
    );
  }
}
