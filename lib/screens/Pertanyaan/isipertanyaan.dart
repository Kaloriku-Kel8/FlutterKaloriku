import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:kaloriku/service/forumService.dart';
import 'package:kaloriku/model/qna.dart';
import 'package:kaloriku/model/komentar.dart';
import 'pertanyaan.dart';

void main() {
  runApp(IsiPertanyaanScreen());
}


class IsiPertanyaanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IsiPertanyaanPage(questionId: ''),
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
  final String questionId;

  const IsiPertanyaanPage({Key? key, required this.questionId}) : super(key: key);

  @override
  _IsiPertanyaanPageState createState() => _IsiPertanyaanPageState();
}

class _IsiPertanyaanPageState extends State<IsiPertanyaanPage> {
  final ForumService _forumService = ForumService();
  late Qna _question;
  List<Komentar> _comments = [];
  bool _isLoading = true;
  bool _liked = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchQuestionDetails();
  }

  Future<void> _fetchQuestionDetails() async {
    try {
      final questionData = await _forumService.getQuestion(widget.questionId);
      setState(() {
        _question = Qna.fromJson(questionData);
        _comments = (questionData['comments'] as List)
            .map((comment) => Komentar.fromJson(comment))
            .toList();
        _liked = questionData['is_liked'] ?? false;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load question: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleLike() async {
    try {
      final isLiked = await _forumService.toggleLike(widget.questionId);
      setState(() {
        _liked = isLiked;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to toggle like: $e')),
      );
    }
  }

  Future<void> _addComment() async {
    if (_commentController.text.isEmpty) return;

    try {
      final comment = await _forumService.addComment(
        widget.questionId, 
        _commentController.text
      );
      
      setState(() {
        _comments.add(comment);
        _commentController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add comment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PertanyaanScreen()),
            );
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
            // Main Question Section
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
                      _question.judulQna ?? 'No Title',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _question.isiQna ?? 'No Content',
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
                          onPressed: _toggleLike,
                        ),
                        SizedBox(width: 4),
                        Text(_liked ? '1' : '0'), // Update logic for total likes
                        SizedBox(width: 16),
                        Icon(FluentIcons.chat_multiple_20_filled, size: 16),
                        SizedBox(width: 4),
                        Text('${_comments.length}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Comments List
            Expanded(
              child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  var comment = _comments[index];
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
                              comment.userUuid ?? 'Anonymous',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              comment.isiKomentar ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Comment Input Section
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
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
                  onPressed: _addComment,
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