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
    required this.createdAt,
    required this.updatedAt,
    this.tags,
    this.user,
  });

  String? id;
  String title;
  String content;
  String? user;
  List<String>? tags;
  DateTime createdAt;
  DateTime updatedAt;

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["_id"],
        title: json["title"] ?? '',
        content: json["content"] ?? '',
        user: json["user"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "content": content,
        "user": user,
        "tags": tags != null ? List<dynamic>.from(tags!.map((x) => x)) : [],
      };
}
