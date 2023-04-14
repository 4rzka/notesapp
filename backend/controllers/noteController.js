const asyncHandler = require('express-async-handler');

const Note = require('../models/noteModel');
const User = require('../models/userModel');

// @desc    Get all notes
// @route   GET /api/notes
// @access  Private
const getNotes = asyncHandler(async (req, res) => {
    const notes = await Note.find({ user: req.user.id });
    res.status(200).json(notes);
});

// @desc    Post note
// @route   POST /api/notes
// @access  Private
const postNote = asyncHandler(async (req, res) => {
    if(!req.body.content) {
        res.status(400);
        throw new Error('Content is required');
    }
    const note = await Note.create({
        title: req.body.title,
        content: req.body.content,
        tags: req.body.tags,
        user: req.user.id
    });
    res.status(200).json(note);
});

// @desc    Update note
// @route   PUT /api/notes
// @access  Private
const updateNote = asyncHandler(async (req, res) => {
    const note = await Note.findById(req.params.id);
    if(!note) {
        res.status(404);
        throw new Error('Note not found');
    }

    const user = await User.findById(req.user.id);

    if(!user) {
        res.status(401);
        throw new Error('User not found');
    }

    if(note.user.toString() !== user.id.toString()) {
        res.status(402);
        throw new Error('Not authorized to update note');
    }

    const updatedNote = await Note.findByIdAndUpdate(req.params.id, {
        title: req.body.title,
        content: req.body.content,
        tags: req.body.tags ? req.body.tags.split(',').map((tag) => tag.trim()) : []
    }, { new: true });
    res.status(200).json(updatedNote);
});

// @desc    Delete note
// @route   DELETE /api/notes
// @access  Private
const deleteNote = asyncHandler(async (req, res) => {
    const note = await Note.findById(req.params.id);
    if(!note) {
        res.status(404);
        throw new Error('Note not found');
    }

    const user = await User.findById(req.user.id);

    if(!user) {
        res.status(401);
        throw new Error('User not found');
    }

    if(note.user.toString() !== user.id.toString()) {
        res.status(402);
        throw new Error('Not authorized to update note');
    }

    await Note.findByIdAndDelete(req.params.id);
    res.status(200).json({ message: 'Note removed' });
});

module.exports = {
    getNotes,
    postNote,
    updateNote,
    deleteNote
};