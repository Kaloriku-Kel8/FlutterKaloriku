import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
  List<Map<String, String>> forumItems = [
    {
      'question': 'Apa itu Flutter?',
      'answer': 'Flutter adalah framework open-source untuk membuat aplikasi mobile, web, dan desktop.',
      'likes': '5'
    },
    {
      'question': 'Bagaimana cara membuat stateful widget?',
      'answer': 'Untuk membuat stateful widget, kita perlu menggunakan StatefulWidget dan State.',
      'likes': '3'
    },
    {
      'question': 'Apa perbedaan stateless dan stateful widget?',
      'answer': 'Stateless widget tidak memiliki state, sementara stateful widget bisa memiliki state yang dapat berubah.',
      'likes': '7'
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
            // Forum posts list
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
                          // Question
                          Text(
                            item['question']!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          // Answer
                          Text(
                            item['answer']!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          // Likes and Actions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(FluentIcons.thumb_like_24_filled),
                                    onPressed: () {
                                      // Handle like action
                                      setState(() {
                                        int likes = int.parse(item['likes']!);
                                        item['likes'] = (likes + 1).toString();
                                      });
                                    },
                                  ),
                                  Text(item['likes']!),
                                ],
                              ),
                              // Reply button
                              TextButton(
                                onPressed: () {
                                  // Handle reply action
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Balas Pertanyaan'),
                                        content: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Tulis balasan...',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Batal'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // Add reply logic
                                              Navigator.pop(context);
                                            },
                                            child: Text('Kirim'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text('Balas'),
                              ),
                            ],
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
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Tanya Pertanyaan Baru'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Masukkan pertanyaan...',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Masukkan jawaban...',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle submit question action
                      Navigator.pop(context);
                    },
                    child: Text('Kirim'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF61CA3D),
      ),
    );
  }
}
