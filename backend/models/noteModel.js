const mongoose = require('mongoose');

const subnoteSchema = mongoose.Schema({
    title: {
        type: String,
        required: true
    },
    content: {
        type: String,
        required: true
    }
});

const noteSchema = mongoose.Schema({
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
        required: true,
        ref: 'User'
    },
    sharedto: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User'
        }
    ],
    tags: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Tag'
        }
    ],
    contacts: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Contact'
        }
    ],
    subnotes: [subnoteSchema],
    isProject: {
        type: Boolean,
        default: false
    },
    isStarted: {
        type: Boolean,
        default: false
    },
    isPinned: {
        type: Boolean,
        default: false
    },
    todos: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Todo'
        }
    ]
}, {
    timestamps: true
});

module.exports = mongoose.model('Note', noteSchema);