const asyncHandler = require('express-async-handler');

const Note = require('../models/noteModel');

// @desc    Get all notes
// @route   GET /api/notes
// @access  Private
const getNotes = asyncHandler(async (req, res) => {
    const notes = await Note.find({});
    res.json(notes);
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
        user: req.user._id});
    res.status(201).json(note);
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

    const updatedNote = await Note.findByIdAndUpdate(req.params.id, {
        title: req.body.title,
        content: req.body.content
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

    await note.remove();
    res.status(200).json({ message: 'Note removed' });
});

module.exports = {
    getNotes,
    postNote,
    updateNote,
    deleteNote
};