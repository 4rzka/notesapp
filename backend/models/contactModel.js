const mongoose = require('mongoose');

const contactSchema = mongoose.Schema({
    user: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
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