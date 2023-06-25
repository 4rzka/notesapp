import 'dart:convert';

class Note {
  Note({
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.tags,
    this.contacts,
    this.isProject,
    this.isStarted,
    this.isPinned,
    this.todos,
    this.id,
    this.subnotes,
    this.sharedto,
    this.v,
  });

  String title;
  String content;
  String? user;
  List<String>? tags;
  List<String>? contacts;
  bool? isProject;
  bool? isStarted;
  bool? isPinned;
  List<String>? todos;
  String? id;
  List<dynamic>? subnotes;
  DateTime createdAt;
  DateTime updatedAt;
  List<String>? sharedto;
  int? v;

  factory Note.fromJson(Map<String, dynamic> json) {
    // Fetch the tag data and create a mapping of tag IDs to names
    Map<String, String> tagIdToNameMap = {
      'tag1': 'Tag 1',
      'tag2': 'Tag 2',
      // Add more tag ID to name mappings
    };

    return Note(
      title: json["title"],
      content: json["content"],
      user: json["user"],
      tags: json["tags"] != null
          ? List<String>.from(json["tags"].map((x) => tagIdToNameMap[x] ?? ''))
          : [],
      contacts: json["contacts"] != null
          ? List<String>.from(json["contacts"].map((x) => x))
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
      sharedto: json["sharedto"] != null
          ? List<String>.from(json["sharedto"].map((x) => x))
          : [],
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "user": user,
        "tags": tags != null ? List<dynamic>.from(tags!.map((x) => x)) : [],
        "contacts":
            contacts != null ? List<dynamic>.from(contacts!.map((x) => x)) : [],
        "isProject": isProject,
        "isStarted": isStarted,
        "isPinned": isPinned,
        "todos": todos != null ? List<dynamic>.from(todos!.map((x) => x)) : [],
        "_id": id ?? "",
        "subnotes":
            subnotes != null ? List<dynamic>.from(subnotes!.map((x) => x)) : [],
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "sharedto":
            sharedto != null ? List<dynamic>.from(sharedto!.map((x) => x)) : [],
        "__v": v,
      };
}

List<Note> noteFromJson(String str) =>
    List<Note>.from(json.decode(str).map((x) => Note.fromJson(x)));

String noteToJson(List<Note> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
