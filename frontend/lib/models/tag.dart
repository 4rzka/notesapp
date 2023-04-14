import 'dart:convert';

List<Tag> tagFromJson(String str) =>
    List<Tag>.from(json.decode(str).map((x) => Tag.fromJson(x)));

String tagToJson(List<Tag> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tag {
  Tag({
    this.id,
    required this.name,
    this.user,
    this.notes,
  });

  String? id;
  String name;
  String? user;
  List<dynamic>? notes;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["_id"],
        name: json["name"],
        user: json["user"],
        notes: List<dynamic>.from(json["notes"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "user": user,
        "notes": List<dynamic>.from(notes!.map((x) => x)),
      };
}
