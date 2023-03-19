class Note {
  String id;
  String? userid;
  String title;
  String content;
  DateTime date;

  Note(
      {required this.id,
      this.userid,
      required this.title,
      required this.content,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userid': userid ?? '',
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      userid: map['userid'],
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
    );
  }
}
