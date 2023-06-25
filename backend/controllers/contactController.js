const asyncHandler = require('express-async-handler');
const Contact = require('../models/contactModel');
const User = require('../models/userModel');

// @desc    Get all contacts
// @route   GET /api/contacts
// @access  Private
const getContacts = asyncHandler(async (req, res) => {
    const contacts = await Contact.find({ user: req.user._id });
    res.json(contacts);
}
);

// @desc    Get a contact
// @route   GET /api/contacts/:id
// @access  Private
const getContact = asyncHandler(async (req, res) => {
    const contact = await Contact.findById(req.params.id);
    if (!contact) {
        res.status(404);
        throw new Error('Contact not found');
    }
    res.json(contact);
}
);

// @desc    Create a contact
// @route   POST /api/contacts
// @access  Private
const postContact = asyncHandler(async (req, res) => {
    const { firstname, lastname, phone, email, address, contactType } = req.body;
    const contact = new Contact({
        firstname,
        lastname,
        phone,
        email,
        address,
        contactType,
        user: req.user._id
    });
    const createdContact = await contact.save();
    res.status(201).json(createdContact);
}
);

// @desc    Update a contact
// @route   PUT /api/contacts/:id
// @access  Private
const updateContact = asyncHandler(async (req, res) => {
    const { firstname, lastname, phone, email, address, contactType } = req.body;
    const contact = await Contact.findById(req.params.id);
    if (!contact) {
        res.status(404);
        throw new Error('Contact not found');
    }

    const user = await User.findById(req.user.id);

    if(!user) {
        res.status(401);
        throw new Error('User not found');
    }

    if(contact.user.toString() !== user.id.toString()) {
        res.status(402);
        throw new Error('Not authorized to update contact');
    }

    contact.firstname = firstname;
    contact.lastname = lastname;
    contact.phone = phone;
    contact.email = email;
    contact.address = address;
    contact.contactType = contactType;

    const updatedContact = await contact.save();
    res.status(200).json(updatedContact);
}
);

// @desc    Delete a contact
// @route   DELETE /api/contacts/:id
// @access  Private
const deleteContact = asyncHandler(async (req, res) => {
    const contact = await Contact.findById(req.params.id);
    if (!contact) {
        res.status(404);
        throw new Error('Contact not found');
    }

    const user = await User.findById(req.user.id);

    if(!user) {
        res.status(401);
        throw new Error('User not found');
    }

    if(contact.user.toString() !== user.id.toString()) {
        res.status(402);
        throw new Error('Not authorized to update note');
    }

    await Contact.findByIdAndRemove(req.params.id);
    res.status(200).json({ message: 'Contact removed' });
}
);

module.exports = { getContacts, getContact, postContact, updateContact, deleteContact };