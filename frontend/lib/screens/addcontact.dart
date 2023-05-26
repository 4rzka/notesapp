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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_contact != null) {
        ApiService.addContact(_contact!);
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
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Contact Type'),
                items: const [
                  DropdownMenuItem(
                    value: 'personal',
                    child: Text('Personal'),
                  ),
                  DropdownMenuItem(
                    value: 'business',
                    child: Text('Business'),
                  ),
                  DropdownMenuItem(
                    value: 'co-operation',
                    child: Text('Co-operation'),
                  ),
                  DropdownMenuItem(
                    value: 'sport',
                    child: Text('sport'),
                  ),
                  DropdownMenuItem(
                    value: 'hobby',
                    child: Text('hobby'),
                  ),
                  DropdownMenuItem(
                    value: 'family',
                    child: Text('family'),
                  ),
                  DropdownMenuItem(
                    value: 'other',
                    child: Text('other'),
                  ),
                ],
                onChanged: (value) => _contact?.contactType = value.toString(),
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
