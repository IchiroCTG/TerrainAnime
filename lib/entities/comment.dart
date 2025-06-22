
class Comment {
  int? id;
  String text;
  String author;
  DateTime date;

  Comment({this.id, required this.text, required this.author, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'date': date.toIso8601String(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      text: map['text'],
      author: map['author'],
      date: DateTime.parse(map['date']),
    );
  }
}