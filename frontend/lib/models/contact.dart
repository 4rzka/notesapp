import 'dart:convert';

enum ContactType {
  personal,
  business,
  coOperation,
  sport,
  hobby,
  family,
  other,
}

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
  ContactType? contactType;
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
        contactType: _parseContactType(json['contactType']),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        id: json['_id'],
      );

  Map<String, dynamic> toJson() => {
        'firstname': firstname,
        'lastname': lastname,
        'phone': phone,
        'email': email,
        'address': address,
        'user': user,
        'contactType': _mapContactType(contactType),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  static ContactType? _parseContactType(String? contactType) {
    switch (contactType) {
      case 'personal':
        return ContactType.personal;
      case 'business':
        return ContactType.business;
      case 'coOperation':
        return ContactType.coOperation;
      case 'sport':
        return ContactType.sport;
      case 'hobby':
        return ContactType.hobby;
      case 'family':
        return ContactType.family;
      case 'other':
        return ContactType.other;
      default:
        return null;
    }
  }

  static String? _mapContactType(ContactType? contactType) {
    switch (contactType) {
      case ContactType.personal:
        return 'personal';
      case ContactType.business:
        return 'business';
      case ContactType.coOperation:
        return 'coOperation';
      case ContactType.sport:
        return 'sport';
      case ContactType.hobby:
        return 'hobby';
      case ContactType.family:
        return 'family';
      case ContactType.other:
        return 'other';
      default:
        return null;
    }
  }
}

List<Contact> contactListFromJson(String str) =>
    List<Contact>.from(json.decode(str).map((x) => Contact.fromJson(x)));

String contactListToJson(List<Contact> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
