import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<Todo> todoFromJson(String str) =>
    List<Todo>.from(json.decode(str).map((x) => Todo.fromJson(x)));

String todoToJson(List<Todo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Todo {
  String? id;
  String name;
  String? user;
  List<String>? notes;
  bool isChecked;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  TextEditingController? controller;
  FocusNode? focusNode;
  UniqueKey? key;

  Todo({
    this.id,
    required this.name,
    this.user,
    this.notes,
    required this.isChecked,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.controller,
    this.focusNode,
    this.key,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json["_id"],
        name: json["name"],
        user: json["user"],
        notes: List<String>.from(json["notes"].map((x) => x)),
        isChecked: json["isChecked"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "user": user,
        "notes": notes != null ? List<dynamic>.from(notes!.map((x) => x)) : [],
        "isChecked": isChecked,
        "createdAt": createdAt != null ? createdAt!.toIso8601String() : "",
        "updatedAt": updatedAt != null ? updatedAt!.toIso8601String() : "",
        "__v": v,
      };
}
