import 'dart:convert';

List<Note> noteFromJson(String str) =>
    List<Note>.from(json.decode(str).map((x) => Note.fromJson(x)));

String noteToJson(List<Note> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Note {
  Note({
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.tags,
    this.isProject,
    this.isStarted,
    this.isPinned,
    this.todos,
    this.id,
    this.subnotes,
    this.v,
  });

  String title;
  String content;
  String? user;
  List<String>? tags;
  bool? isProject;
  bool? isStarted;
  bool? isPinned;
  List<String>? todos;
  String? id;
  List<dynamic>? subnotes;
  DateTime createdAt;
  DateTime updatedAt;
  int? v;

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        title: json["title"],
        content: json["content"],
        user: json["user"],
        tags: json["tags"] != null
            ? List<String>.from(json["tags"].map((x) => x))
            : [],
        isProject: json["isProject"],
        isStarted: json["isStarted"],
        isPinned: json["isPinned"],
        todos: json["todos"] != null
            ? List<String>.from(json["todos"].map((x) => x))
            : [],
        id: json["_id"],
        subnotes: json["subnotes"] != null
            ? List<dynamic>.from(json["subnotes"].map((x) => x))
            : [],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "user": user,
        "tags": tags != null ? List<dynamic>.from(tags!.map((x) => x)) : [],
        "isProject": isProject,
        "isStarted": isStarted,
        "isPinned": isPinned,
        "todos": todos != null ? List<dynamic>.from(todos!.map((x) => x)) : [],
        "_id": id,
        "subnotes":
            subnotes != null ? List<dynamic>.from(subnotes!.map((x) => x)) : [],
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
