const asyncHandler = require('express-async-handler');

// @desc    Get all notes
// @route   GET /api/notes
// @access  Private
const getNotes = asyncHandler(async (req, res) => {
    res.status(200).json({ message: 'Get notes' });
});

// @desc    Post note
// @route   POST /api/notes
// @access  Private
const postNote = asyncHandler(async (req, res) => {
    res.status(200).json({ message: 'Post note' });
});

// @desc    Update note
// @route   PUT /api/notes
// @access  Private
const updateNote = asyncHandler(async (req, res) => {
    res.status(200).json({ message: `Update note ${req.params.id}` });
});

// @desc    Delete note
// @route   DELETE /api/notes
// @access  Private
const deleteNote = asyncHandler(async (req, res) => {
    res.status(200).json({ message: `Delete note ${req.params.id}` });
});

module.exports = {
    getNotes,
    postNote,
    updateNote,
    deleteNote
};