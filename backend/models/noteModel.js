const mongoose = require('mongoose');

const noteSchema = mongoose.Schema({
    id: {
        type: String,
        required: true
    },
    title: {
        type: String,
        required: true
    },
    content: {
        type: String,
        required: true
    },
    user: {
        type: mongoose.Schema.Types.ObjectId,
        required: false,
        ref: 'User'
    }
}, {
    timestamps: true
});

module.exports = mongoose.model('Note', noteSchema);