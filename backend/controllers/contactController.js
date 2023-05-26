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
    if (contact) {
        contact.firstname = firstname;
        contact.lastname = lastname;
        contact.phone = phone;
        contact.email = email;
        contact.address = address;
        contact.contactType = contactType;
        const updatedContact = await contact.save();
        res.json(updatedContact);
    } else {
        res.status(404);
        throw new Error('Contact not found');
    }
}
);

// @desc    Delete a contact
// @route   DELETE /api/contacts/:id
// @access  Private
const deleteContact = asyncHandler(async (req, res) => {
    const contact = await Contact.findById(req.params.id);
    if (contact) {
        await contact.remove();
        res.json({ message: 'Contact removed' });
    } else {
        res.status(404);
        throw new Error('Contact not found');
    }
}
);

module.exports = { getContacts, postContact, updateContact, deleteContact };