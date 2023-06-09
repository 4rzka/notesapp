import 'dart:convert';

List<Tag> tagFromJson(String str) =>
    List<Tag>.from(json.decode(str).map((x) => Tag.fromJson(x)));

String tagToJson(List<Tag> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tag {
  String? id;
  String name;
  String? user;
  List<String>? notes;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Tag({
    this.id,
    required this.name,
    this.user,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["_id"],
        name: json["name"],
        user: json["user"],
        notes: List<String>.from(json["notes"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "user": user,
        "notes": notes != null ? List<dynamic>.from(notes!.map((x) => x)) : [],
        "createdAt": createdAt != null ? createdAt!.toIso8601String() : "",
        "updatedAt": updatedAt != null ? updatedAt!.toIso8601String() : "",
        "__v": v,
      };
}
