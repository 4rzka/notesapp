const mongoose = require('mongoose');

const contactSchema = mongoose.Schema({
    // phone contact just as it is in the phone
    firstname: {
        type: String,
        required: true
    },
    lastname: {
        type: String,
        required: false
    },
    phone: {
        type: String,
        required: true
    },
    email: {
        type: String,
        required: false
    },
    // contact created by the user in the app
    address: {
        type: String,
        required: false
    },
    user: {
        type: mongoose.Schema.Types.ObjectId,
        required: false,
        ref: 'User'
    },
    contactType: {
        type: String,
        enum: ['personal', 'business', 'co-operation', 'sport', 'hobby', 'family', 'other']
    }
}, {
    timestamps: true
});

module.exports = mongoose.model('Contact', contactSchema);