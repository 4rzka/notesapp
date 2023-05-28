import 'dart:convert';
import 'package:frontend/models/note.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import '../variables/variables.dart';
import '../models/contact.dart';
import '../models/tag.dart';

class ApiService {
  static const String _baseUrl = '$hostUrl/api';
  static const String _loginUrl = '$_baseUrl/users/login';
  static const String _registerUrl = '$_baseUrl/users/';
  static const String _tagsUrl = '$_baseUrl/tags';
  static const String _contactsUrl = '$_baseUrl/contacts';
  static String? token;
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  static Future<void> addNote(Note note) async {
    Uri requestUrl = Uri.parse('$_baseUrl/notes');
    print('Request URL: $requestUrl');
    print('Request Body: ${note.toJson()}');
    var response =
        await http.post(requestUrl, body: jsonEncode(note.toJson()), headers: {
      'Authorization': 'Bearer ${ApiService.token}',
      'Content-Type': 'application/json',
    });
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
  }

  static Future<void> deleteNote(noteId) async {
    Uri requestUrl = Uri.parse('$_baseUrl/notes/$noteId');
    var response = await http.delete(requestUrl, headers: {
      'Authorization': 'Bearer ${ApiService.token}',
    });
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
  }

  static Future<void> updateNote(Note note) async {
    Uri requestUrl = Uri.parse('$_baseUrl/notes/${note.id}');
    print('JSON to be sent: ${json.encode(note.toJson())}');
    var response =
        await http.put(requestUrl, body: json.encode(note.toJson()), headers: {
      'Authorization': 'Bearer ${ApiService.token}',
      'Content-Type': 'application/json',
    });
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
  }

  static Future<List<Note>> fetchNotes() async {
    Uri requestUrl = Uri.parse('$_baseUrl/notes');
    var response = await http.get(requestUrl, headers: {
      'Authorization': 'Bearer ${ApiService.token}',
    });
    var decoded = jsonDecode(response.body);
    List<Note> notes = [];

    if (decoded is List) {
      for (var noteMap in decoded) {
        Note newNote = Note.fromJson(noteMap.cast<String, dynamic>());
        notes.add(newNote);
      }
    } else if (decoded is Map) {
      Note newNote = Note.fromJson(decoded.cast<String, dynamic>());
      notes.add(newNote);
    }

    return notes;
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse(_loginUrl),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      token = responseData['token'];
      return responseData;
    }
    if (response.statusCode == 401) {
      throw Exception('Invalid email or password');
    } else {
      throw Exception('Failed to log in');
    }
  }

  static void setToken(String token) {
    _headers['Authorization'] = 'Bearer $token';
  }

  static Future<Map<String, dynamic>> register(
      String email, String password, String name) async {
    final response = await http.post(Uri.parse(_registerUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
          'name': name,
        }));

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }

  static Future<List<Tag>> fetchTags() async {
    Uri requestUrl = Uri.parse(_tagsUrl);
    var response = await http.get(requestUrl, headers: {
      'Authorization': 'Bearer ${ApiService.token}',
    });
    var decoded = jsonDecode(response.body);
    List<Tag> tags = [];

    if (decoded is List) {
      for (var tagMap in decoded) {
        Tag newTag = Tag.fromJson(tagMap.cast<String, dynamic>());
        tags.add(newTag);
      }
    } else if (decoded is Map) {
      Tag newTag = Tag.fromJson(decoded.cast<String, dynamic>());
      tags.add(newTag);
    }

    return tags;
  }

  static Future<void> addTag(Tag tag) async {
    Uri requestUrl = Uri.parse('$_baseUrl/tags');
    var response =
        await http.post(requestUrl, body: jsonEncode(tag.toJson()), headers: {
      'Authorization': 'Bearer ${ApiService.token}',
      'Content-Type': 'application/json',
    });
  }

  static Future<void> updateTag(Tag tag) async {
    Uri requestUrl = Uri.parse('$_tagsUrl/${tag.id}');
    var response =
        await http.put(requestUrl, body: json.encode(tag.toJson()), headers: {
      'Authorization': 'Bearer ${ApiService.token}',
      'Content-Type': 'application/json',
    });
  }

  static Future<void> deleteTag(tagId) async {
    Uri requestUrl = Uri.parse('$_tagsUrl/$tagId');
    var response = await http.delete(requestUrl, headers: {
      'Authorization': 'Bearer ${ApiService.token}',
    });
  }

  static Future<List<Contact>> fetchContacts() async {
    Uri requestUrl = Uri.parse(_contactsUrl);
    var response = await http.get(requestUrl, headers: {
      'Authorization': 'Bearer ${ApiService.token}',
    });
    var decoded = jsonDecode(response.body);
    List<Contact> contacts = [];

    if (decoded is List) {
      for (var contactMap in decoded) {
        Contact newContact =
            Contact.fromJson(contactMap.cast<String, dynamic>());
        contacts.add(newContact);
      }
    } else if (decoded is Map) {
      Contact newContact = Contact.fromJson(decoded.cast<String, dynamic>());
      contacts.add(newContact);
    }

    return contacts;
  }

  static Future<void> addContact(Contact contact) async {
    Uri requestUrl = Uri.parse(_contactsUrl);
    var response = await http
        .post(requestUrl, body: jsonEncode(contact.toJson()), headers: {
      'Authorization': 'Bearer ${ApiService.token}',
      'Content-Type': 'application/json',
    });
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
  }

  static Future<void> updateContact(Contact contact) async {
    Uri requestUrl = Uri.parse('$_contactsUrl/${contact.id}');
    var response = await http
        .put(requestUrl, body: json.encode(contact.toJson()), headers: {
      'Authorization': 'Bearer ${ApiService.token}',
      'Content-Type': 'application/json',
    });
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
  }

  static Future<void> deleteContact(contactId) async {
    Uri requestUrl = Uri.parse('$_contactsUrl/$contactId');
    var response = await http.delete(requestUrl, headers: {
      'Authorization': 'Bearer ${ApiService.token}',
    });
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
  }
}
