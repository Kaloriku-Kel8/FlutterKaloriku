import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../Home/home_menu.dart';
import '../profil/profil.dart';
import 'tambahpertanyaan.dart';
import 'isipertanyaan.dart';
import 'package:kaloriku/service/forumService.dart';
import 'package:kaloriku/model/qna.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class IsiPertanyaanScreen extends StatelessWidget {
  final String questionId;

  const IsiPertanyaanScreen({Key? key, required this.questionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Pertanyaan')),
      body: Center(
        child: Text('Question ID: $questionId'),
      ),
    );
  }
}

class ForumPage extends StatefulWidget {
  @override
  ForumPageState createState() => ForumPageState();
}

class ForumPageState extends State<ForumPage> {
  int _selectedIndex = 1;
  List<Map<String, dynamic>> forumItems = [];
  final ForumService _forumService = ForumService();
  final TextEditingController _searchController = TextEditingController();
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _fetchQuestions();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('user_id');
    });
  }

  Future<void> _fetchQuestions({String? keyword}) async {
    try {
      final response = await _forumService.getAllQuestions(keyword: keyword);
      if (mounted) {
        setState(() {
          forumItems = response
              .map((question) => {
                    'id': question['id_qna'],
                    'question': question['judul_qna'],
                    'description': question['isi_qna'],
                    'date': question['tanggal'] ?? '',
                    'userName': question['user_name'] ?? '',
                    'likes': question['like_count'] ?? 0,
                    'replies': question['komentar_count'] ?? 0,
                    'liked':
                        question['likes']?.contains(currentUserId) ?? false,
                  })
              .toList();
        });

        if (forumItems.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(keyword == null || keyword.isEmpty
                  ? 'Belum ada pertanyaan.'
                  : 'Tidak ditemukan pertanyaan dengan kata kunci "$keyword".'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pertanyaan tidak ditemukan')),
        );
      }
    }
  }

  Future<void> _toggleLike(int id) async {
    try {
      final questionId = id.toString();
      final isLiked = await _forumService.toggleLike(questionId);

      if (mounted) {
        setState(() {
          var item = forumItems.firstWhere((element) => element['id'] == id);
          item['liked'] = isLiked;
          item['likes'] += isLiked ? 1 : -1;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengubah like: $e')),
        );
      }
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

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeMenuScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PertanyaanScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(25.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari Pertanyaan...',
                        hintStyle: const TextStyle(color: Colors.black45),
                        border: InputBorder.none,
                        prefixIcon:
                            const Icon(Icons.search, color: Color(0xFF000000)),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _onSearch,
                        ),
                      ),
                      onSubmitted: (_) => _onSearch(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Divider(),
              const SizedBox(height: 6),
              // Forum posts list
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => _fetchQuestions(),
                  child: forumItems.isEmpty
                      ? Center(
                          child: Text(
                            _searchController.text.trim().isEmpty
                                ? 'Belum ada pertanyaan.'
                                : 'Tidak ada hasil untuk pencarian "${_searchController.text.trim()}".',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                        )
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
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item['question'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Posted by ${item['userName']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
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
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: Icon(
                                              item['liked']
                                                  ? FluentIcons
                                                      .thumb_like_20_filled
                                                  : FluentIcons
                                                      .thumb_like_20_regular,
                                              size: 16,
                                              color: item['liked']
                                                  ? Colors.blue
                                                  : Colors.grey,
                                            ),
                                            onPressed: () =>
                                                _toggleLike(item['id']),
                                          ),
                                          const SizedBox(width: 4),
                                          Text('${item['likes']}'),
                                          const SizedBox(width: 16),
                                          const Icon(
                                            FluentIcons.chat_multiple_20_filled,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Text('${item['replies']}'),
                                          const Spacer(),
                                          Text(
                                            item['date'],
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      IsiPertanyaanPage(
                                                    questionId:
                                                        item['id'].toString(),
                                                  ),
                                                ),
                                              ).then((_) => _fetchQuestions());
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
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BuatPertanyaanScreen(),
            ),
          ).then((_) => _fetchQuestions());
        },
        backgroundColor: const Color(0xFF61CA3D),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          _buildBottomNavItem(
            icon: _selectedIndex == 0
                ? FluentIcons.home_12_filled
                : FluentIcons.home_12_regular,
            label: 'Beranda',
          ),
          _buildBottomNavItem(
            icon: _selectedIndex == 1
                ? FluentIcons.chat_12_filled
                : FluentIcons.chat_12_regular,
            label: 'Pertanyaan',
          ),
          _buildBottomNavItem(
            icon: _selectedIndex == 2
                ? FluentIcons.person_12_filled
                : FluentIcons.person_12_regular,
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black, // Change to green for consistency
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem({
    required IconData icon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}
