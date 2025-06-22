
import 'package:flutter/material.dart';
import 'package:terrain_anime/database/database_helper.dart';
import 'package:terrain_anime/entities/comment.dart';
import 'package:intl/intl.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final _textController = TextEditingController();
  final _authorController = TextEditingController();
  Comment? _editingComment;

  @override
  void initState() {
    super.initState();
    _refreshComments();
  }

  Future<void> _refreshComments() async {
    setState(() {});
  }

  Future<void> _saveComment() async {
    final text = _textController.text;
    final author = _authorController.text;
    if (text.isNotEmpty && author.isNotEmpty) {
      final comment = Comment(
        text: text,
        author: author,
        date: DateTime.now(),
      );
      if (_editingComment == null) {
        await _dbHelper.createComment(comment);
      } else {
        await _dbHelper.updateComment(comment.copyWith(id: _editingComment!.id));
        _editingComment = null;
      }
      _textController.clear();
      _authorController.clear();
      _refreshComments();
    }
  }

  void _editComment(Comment comment) {
    setState(() {
      _editingComment = comment;
      _textController.text = comment.text;
      _authorController.text = comment.author;
    });
  }

  Future<void> _deleteComment(int id) async {
    await _dbHelper.deleteComment(id);
    _refreshComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comentarios')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(labelText: 'Comentario'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _authorController,
                    decoration: const InputDecoration(labelText: 'Autor'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _saveComment,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Comment>>(
                future: _dbHelper.getComments(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final comments = snapshot.data!;
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(comment.text),
                          subtitle: Text(
                            'Por ${comment.author} - ${DateFormat('yyyy-MM-dd HH:mm').format(comment.date)}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editComment(comment),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteComment(comment.id!),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension CommentCopyWith on Comment {
  Comment copyWith({int? id, String? text, String? author, DateTime? date}) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      date: date ?? this.date,
    );
  }
}