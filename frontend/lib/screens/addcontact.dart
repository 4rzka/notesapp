import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:frontend/models/contact.dart' as contactmodel;
import 'package:frontend/services/api_service.dart';
import 'package:permission_handler/permission_handler.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  contactmodel.Contact? _contact;
  contactmodel.ContactType? _selectedContactType;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('_contact: $_contact');
      print('_contact?.contactType: ${_contact?.contactType}');
      _contact = contactmodel.Contact(
        firstname: _firstNameController.text,
        lastname: _lastNameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        address: _addressController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        contactType: _selectedContactType,
      );
      if (_contact != null) {
        ApiService.addContact(_contact!).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Contact added successfully'),
            ),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add all required fields'),
          ),
        );
      }
    }
  }

  Future<void> importFromPhone() async {
    if (await Permission.contacts.request().isGranted) {
      Contact? contact = await ContactsService.openDeviceContactPicker();
      if (contact != null) {
        // Update the controllers
        _firstNameController.text = contact.givenName ?? '';
        _lastNameController.text = contact.familyName ?? '';
        _phoneController.text = contact.phones?.first.value ?? '';
        _emailController.text = contact.emails?.first.value ?? '';
        // Assuming that the contact does not have an address in your app
        _addressController.text = '';
      }
    }
  }

  contactmodel.ContactType? _parseContactType(String? value) {
    switch (value) {
      case 'personal':
        return contactmodel.ContactType.personal;
      case 'business':
        return contactmodel.ContactType.business;
      case 'co-operation':
        return contactmodel.ContactType.coOperation;
      case 'sport':
        return contactmodel.ContactType.sport;
      case 'hobby':
        return contactmodel.ContactType.hobby;
      case 'family':
        return contactmodel.ContactType.family;
      case 'other':
        return contactmodel.ContactType.other;
      default:
        return null;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a first name';
                  }
                  return null;
                },
                onSaved: (value) => _contact?.firstname = value!,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last name'),
                onSaved: (value) => _contact?.lastname = value,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
                onSaved: (value) => _contact?.phone = value!,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (value) => _contact?.email = value,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                onSaved: (value) => _contact?.address = value,
              ),
              DropdownButtonFormField<contactmodel.ContactType>(
                decoration: const InputDecoration(labelText: 'Contact Type'),
                value: _selectedContactType,
                items: const [
                  DropdownMenuItem(
                    value: contactmodel.ContactType.personal,
                    child: Text('Personal'),
                  ),
                  DropdownMenuItem(
                    value: contactmodel.ContactType.business,
                    child: Text('Business'),
                  ),
                  DropdownMenuItem(
                    value: contactmodel.ContactType.coOperation,
                    child: Text('Co-operation'),
                  ),
                  DropdownMenuItem(
                    value: contactmodel.ContactType.sport,
                    child: Text('Sport'),
                  ),
                  DropdownMenuItem(
                    value: contactmodel.ContactType.hobby,
                    child: Text('Hobby'),
                  ),
                  DropdownMenuItem(
                    value: contactmodel.ContactType.family,
                    child: Text('Family'),
                  ),
                  DropdownMenuItem(
                    value: contactmodel.ContactType.other,
                    child: Text('Other'),
                  ),
                ],
                validator: (value) {
                  if (value == null) {
                    return 'Please select a contact type';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _selectedContactType = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: importFromPhone,
                child: const Text('Import from Phone'),
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
