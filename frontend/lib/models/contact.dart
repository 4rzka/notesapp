import 'dart:convert';

class Contact {
  Contact({
    required this.firstname,
    this.lastname,
    required this.phone,
    this.email,
    this.address,
    this.user,
    this.contactType,
    required this.createdAt,
    required this.updatedAt,
    this.id,
  });

  String firstname;
  String? lastname;
  String phone;
  String? email;
  String? address;
  String? user;
  String? contactType;
  DateTime createdAt;
  DateTime updatedAt;
  String? id;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        firstname: json['firstname'],
        lastname: json['lastname'],
        phone: json['phone'],
        email: json['email'],
        address: json['address'],
        user: json['user'],
        contactType: json['contactType'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'firstname': firstname,
        'lastname': lastname,
        'phone': phone,
        'email': email,
        'address': address,
        'user': user,
        'contactType': contactType,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

List<Contact> contactListFromJson(String str) =>
    List<Contact>.from(json.decode(str).map((x) => Contact.fromJson(x)));

String contactListToJson(List<Contact> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
