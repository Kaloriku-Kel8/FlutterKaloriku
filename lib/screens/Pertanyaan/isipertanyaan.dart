import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

void main() {
  runApp(IsiPertanyaanScreen());
}

class IsiPertanyaanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IsiPertanyaanPage(),
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'Roboto',
            ),
      ),
    );
  }
}

class IsiPertanyaanPage extends StatefulWidget {
  @override
  _IsiPertanyaanPageState createState() => _IsiPertanyaanPageState();
}

class _IsiPertanyaanPageState extends State<IsiPertanyaanPage> {
  bool _liked = false;
  final List<Map<String, String>> comments = [
    {
      'name': 'Arnold',
      'comment': 'Mungkin bisa dengan makan dengan gizi yang cukup si',
      'date': '23/09/2024',
    },
    {
      'name': 'Ade Rai',
      'comment': 'Bisa dengan meminum whey protein',
      'date': '23/09/2024',
    },
    {
      'name': 'John Cena',
      'comment': 'Gizi cukup sama olahraga si, soalnya kalo dari pengalamanku itu berhasil',
      'date': '23/09/2024',
    },
    {
      'name': 'Adi',
      'comment': 'Bisa dengan makan terus jangan lupa ngegym',
      'date': '23/09/2024',
    },
    {
      'name': 'Young Lex',
      'comment': 'Makan aja si yang banyak kalo aku ya bang, makanbang',
      'date': '23/09/2024',
    },
  ];

  bool _isReplying = false;
  String _replyText = "";

  void toggleLike() {
    setState(() {
      _liked = !_liked;
    });
  }

  void toggleReplyBox() {
    setState(() {
      _isReplying = !_isReplying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background putih untuk tampilan bersih
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Kembali",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kotak pertanyaan utama
            Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Menambah Berat Badan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Barangkali di sini ada yang sudah berhasil meningkatkan berat badan, boleh tahu tipsnya?',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _liked ? FluentIcons.thumb_like_20_filled : FluentIcons.thumb_like_20_regular,
                            size: 16,
                          ),
                          onPressed: toggleLike,
                        ),
                        SizedBox(width: 4),
                        Text(_liked ? '3' : '2'), // Jumlah suka diperbarui
                        SizedBox(width: 16),
                        Icon(FluentIcons.chat_multiple_20_filled, size: 16),
                        SizedBox(width: 4),
                        Text('9'),
                        SizedBox(width: 8), // Jarak kecil sebelum tanggal
                        Text(
                          '23/09/2024',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: toggleReplyBox,
                          child: Text(
                            'Balas',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Daftar komentar
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  var comment = comments[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment['name']!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              comment['comment']!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              comment['date']!,
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Kotak teks balasan
            if (_isReplying)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        _replyText = value;
                      },
                      decoration: InputDecoration(
                        hintText: "Tulis balasan...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      if (_replyText.isNotEmpty) {
                        setState(() {
                          comments.add({
                            'name': 'Anda',
                            'comment': _replyText,
                            'date': '04/12/2024',
                          });
                          _replyText = "";
                          _isReplying = false;
                        });
                      }
                    },
                    icon: Icon(Icons.send, color: Colors.green),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
