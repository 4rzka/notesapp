import 'package:flutter/material.dart';
import 'package:frontend/models/contact.dart' as contactmodel;
import 'package:frontend/screens/editcontact.dart';
import 'package:frontend/services/api_service.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late Future<List<contactmodel.Contact>> _contactsFuture;

  @override
  void initState() {
    super.initState();
    _contactsFuture = ApiService.fetchContacts();
  }

  Future<void> _handleLongPress(contactmodel.Contact contact) async {
    String? action = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () => Navigator.of(context).pop('edit'),
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () => Navigator.of(context).pop('delete'),
            ),
          ],
        );
      },
    );

    if (action == 'edit') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditContact(contact: contact),
        ),
      );
    } else if (action == 'delete') {
      await ApiService.deleteContact(contact);
      setState(() {
        _contactsFuture = ApiService.fetchContacts();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: FutureBuilder<List<contactmodel.Contact>>(
        future: _contactsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final contacts = snapshot.data!;
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(contact.firstname[0]),
                  ),
                  title: Text('${contact.firstname} ${contact.lastname}'),
                  subtitle: Text(contact.email ?? 'No email'),
                  onLongPress: () => _handleLongPress(contact),
                );
              },
            );
          }
        },
      ),
    );
  }
}
