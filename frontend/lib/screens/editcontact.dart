import 'package:flutter/material.dart';
import 'package:frontend/models/contact.dart' as contactmodel;
import 'package:frontend/services/api_service.dart';

import '../models/contact.dart';

class EditContact extends StatefulWidget {
  final contactmodel.Contact contact;

  const EditContact({Key? key, required this.contact}) : super(key: key);

  @override
  _EditContactState createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  ContactType? _contactType;

  @override
  void initState() {
    super.initState();

    _firstNameController =
        TextEditingController(text: widget.contact.firstname);
    _lastNameController = TextEditingController(text: widget.contact.lastname);
    _phoneController = TextEditingController(text: widget.contact.phone);
    _emailController = TextEditingController(text: widget.contact.email);
    _addressController = TextEditingController(text: widget.contact.address);
    _contactType = widget.contact.contactType;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ApiService.updateContact(widget.contact);
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
        title: const Text('Edit Contact'),
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
                onSaved: (value) => widget.contact.firstname = value!,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last name'),
                onSaved: (value) => widget.contact.lastname = value,
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
                onSaved: (value) => widget.contact.phone = value!,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (value) => widget.contact.email = value,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                onSaved: (value) => widget.contact.address = value,
              ),
              DropdownButtonFormField(
                  value: _contactType,
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
                  onChanged: (value) =>
                      setState(() => _contactType = value as ContactType?),
                  onSaved: (value) {
                    widget.contact.contactType = value as ContactType;
                  }),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
