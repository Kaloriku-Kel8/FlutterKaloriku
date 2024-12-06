import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:kaloriku/service/forumService.dart';
import 'package:kaloriku/model/qna.dart';
import 'package:kaloriku/model/like.dart';
import 'package:kaloriku/model/komentar.dart';
import 'dart:convert'; // This is the library for JSON decoding
import 'pertanyaan.dart';



class IsiPertanyaanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IsiPertanyaanPage(questionId: '123'), // Example questionId
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

  const IsiPertanyaanPage({Key? key, required this.questionId})
      : super(key: key);

  @override
  _IsiPertanyaanPageState createState() => _IsiPertanyaanPageState();
}

class _IsiPertanyaanPageState extends State<IsiPertanyaanPage> {
  final ForumService _forumService = ForumService();
  Qna? _question;
  bool _isLoading = true;
  bool _liked = false;
  final TextEditingController _commentController = TextEditingController();
  final String _currentUserUuid =
      'currentUserUuid'; // Replace with current user UUID

  @override
  void initState() {
    super.initState();
    _fetchQuestionDetails();
  }

  Future<void> _fetchQuestionDetails() async {
    try {
      final questionData = await _forumService.getQuestion(widget.questionId);

      Map<String, dynamic> decodedData;
      if (questionData is String) {
        decodedData = jsonDecode(questionData as String);
      } else {
        decodedData = questionData;
      }

      setState(() {
        _question = Qna.fromJson(decodedData);
        _liked = _question?.likes
                ?.any((like) => like.userUuid == _currentUserUuid) ??
            false;
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

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty || _question == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Komentar tidak boleh kosong')));
      return;
    }

    final newCommentText = _commentController.text.trim();
    setState(() {
      _question?.komentar?.add(
          Komentar(userCommentName: 'Anonymous', isiKomentar: newCommentText));
      _commentController.clear();
    });

    try {
      final newComment =
          await _forumService.addComment(widget.questionId, newCommentText);
      setState(() {
        _question?.komentar?.last = newComment;
      });
    } catch (e) {
      setState(() {
        _question?.komentar?.removeLast();
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan komentar: $e')));
    }
  }

  Future<void> _toggleLike() async {
    if (_question == null) return;

    try {
      final isLiked = await _forumService.toggleLike(widget.questionId);

      if (mounted) {
        setState(() {
          _liked = isLiked;

          if (_liked) {
            _question?.likes?.add(
                Like(userUuid: _currentUserUuid, idQna: widget.questionId));
            _question?.likeCount =
                (_question?.likeCount ?? 0) + 1; // Increment like count
          } else {
            _question?.likes
                ?.removeWhere((like) => like.userUuid == _currentUserUuid);
            _question?.likeCount =
                (_question?.likeCount ?? 0) - 1; // Decrement like count
          }
        });
      }
    } catch (e) {
      setState(() {
        _liked = !_liked; // Revert the like state
        if (_liked) {
          _question?.likes
              ?.add(Like(userUuid: _currentUserUuid, idQna: widget.questionId));
        } else {
          _question?.likes
              ?.removeWhere((like) => like.userUuid == _currentUserUuid);
        }
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to toggle like: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = _question;
    if (question == null) {
      return Scaffold(
        body: Center(child: Text('No data available.')),
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
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => PertanyaanScreen()));
          },
        ),
        title: Text("Kembali", style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.judulQna ?? 'No Title',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    SizedBox(height: 8),
                    Text(question.isiQna ?? 'No Content',
                        style: TextStyle(fontSize: 14, color: Colors.black54)),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _liked
                                ? FluentIcons.thumb_like_20_filled
                                : FluentIcons.thumb_like_20_regular,
                            color: _liked ? Colors.blue : Colors.black,
                            size: 16,
                          ),
                          onPressed: _toggleLike,
                        ),
                        SizedBox(width: 4),
                        Text('${question.likeCount}'),
                        SizedBox(width: 16),
                        Icon(FluentIcons.chat_multiple_20_filled, size: 16),
                        SizedBox(width: 4),
                        Text('${question.komentarCount}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _question?.komentar?.length ?? 0,
                itemBuilder: (context, index) {
                  final comment = _question!.komentar![index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.userCommentName ?? '',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            SizedBox(height: 4),
                            Text(
                              comment.isiKomentar ?? '',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
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
