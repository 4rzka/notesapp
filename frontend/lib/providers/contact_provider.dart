import 'package:flutter/cupertino.dart';
import '../models/contact.dart';
import '../services/api_service.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> contacts = [];
  bool isLoading = true;

  ContactProvider() {
    fetchContacts();
  }

  void addContact(Contact contact) {
    contacts.add(contact);
    notifyListeners();
    ApiService.addContact(contact);
  }

  void updateContact(Contact contact) {
    int contactIndex = contacts
        .indexOf(contacts.firstWhere((element) => element.id == contact.id));
    contacts[contactIndex] = contact;
    notifyListeners();
    ApiService.updateContact(contact);
  }

  void deleteContact(Contact contact) {
    int contactIndex = contacts
        .indexOf(contacts.firstWhere((element) => element.id == contact.id));
    contacts.removeAt(contactIndex);
    notifyListeners();
    ApiService.deleteContact(contact.id);
  }

  void fetchContacts() async {
    contacts = await ApiService.fetchContacts();
    isLoading = false;
    notifyListeners();
  }
}
