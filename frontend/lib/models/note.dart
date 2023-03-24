import 'dart:convert';

List<Note> noteFromJson(String str) =>
    List<Note>.from(json.decode(str).map((x) => Note.fromJson(x)));

String noteToJson(List<Note> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Note {
  Note({
    this.id,
    required this.title,
    required this.content,
    this.user,
  });

  String? id;
  String title;
  String content;
  String? user;

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["_id"],
        title: json["title"],
        content: json["content"],
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "content": content,
        "user": user,
      };
}
