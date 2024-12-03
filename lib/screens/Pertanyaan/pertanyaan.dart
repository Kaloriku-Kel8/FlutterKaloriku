import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../Home/home_menu.dart';
import '../profil/profil.dart';
import 'tambahpertanyaan.dart';
import 'isipertanyaan.dart';
import 'package:kaloriku/service/forumService.dart';
import 'package:kaloriku/model/qna.dart';
import 'package:kaloriku/model/like.dart'; // Added Like model import

void main() {
  runApp(const PertanyaanScreen());
}

class PertanyaanScreen extends StatelessWidget {
  const PertanyaanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ForumPage(),
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'Roboto',
            ),
      ),
    );
  }
}

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  int _selectedIndex = 1;
  List<Map<String, dynamic>> forumItems = [];
  final ForumService _forumService = ForumService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions({String? keyword}) async {
    try {
      final questions = await _forumService.getAllQuestions(keyword: keyword);
      setState(() {
        forumItems = questions.map((question) => {
          'id': question['id_qna'],
          'question': question['judul_qna'],
          'description': question['isi_qna'],
          'date': question['created_at'] ?? '',
          'likes': question['likes_count'] ?? 0,
          'replies': question['comments_count'] ?? 0,
          'liked': question['is_liked'] ?? false,
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch questions: $e')),
      );
    }
  }

  Future<void> _toggleLike(int id) async {
    try {
      final questionId = id.toString();
      final isLiked = await _forumService.toggleLike(questionId);
      setState(() {
        var item = forumItems.firstWhere((element) => element['id'] == id);
        item['liked'] = isLiked;
        item['likes'] += isLiked ? 1 : -1;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to toggle like: $e')),
      );
    }
  }

  void _onSearch() {
    final keyword = _searchController.text.trim();
    _fetchQuestions(keyword: keyword);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeMenuScreen()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PertanyaanScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 16),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(25.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari Pertanyaan...',
                      hintStyle: TextStyle(color: Colors.black45),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Color(0xFF000000)),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _onSearch,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 6),
            Divider(),
            SizedBox(height: 6),
            // Forum posts list
            Expanded(
              child: forumItems.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: forumItems.length,
                      itemBuilder: (context, index) {
                        var item = forumItems[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Material(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(12.0),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['question'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item['description'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          item['liked']
                                              ? FluentIcons.thumb_like_20_filled
                                              : FluentIcons.thumb_like_20_regular,
                                          size: 16,
                                        ),
                                        onPressed: () {
                                          _toggleLike(item['id']);
                                        },
                                      ),
                                      Text('${item['likes']}'),
                                      const SizedBox(width: 16),
                                      const Icon(FluentIcons.chat_multiple_20_filled, size: 16),
                                      const SizedBox(width: 4),
                                      Text('${item['replies']}'),
                                      const SizedBox(width: 16),
                                      Text(
                                        item['date'],
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          // TODO: Navigate to question details page
                                          // You'll need to implement a details page that uses the question ID
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => IsiPertanyaanScreen(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Lihat',
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
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BuatPertanyaanScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF61CA3D),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 0 ? FluentIcons.home_12_filled : FluentIcons.home_12_regular,
            ),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 1 ? FluentIcons.chat_12_filled : FluentIcons.chat_12_regular,
            ),
            label: 'Pertanyaan',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2 ? FluentIcons.person_12_filled : FluentIcons.person_12_regular,
            ),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
      ),
    );
  }
}