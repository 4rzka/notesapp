const asyncHandler = require('express-async-handler');

const Note = require('../models/noteModel');
const User = require('../models/userModel');
const Tag = require('../models/tagModel');
const Todo = require('../models/todoModel');
const { default: mongoose } = require('mongoose');

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

    const { title, content, tags, todos } = req.body;

    // create the note without tags and todos so that we can get the note id to add to tags and todos
    const note = await Note.create({
        title,
        content,
        user: req.user.id
    });

    // create new tags
    const tagIds = await Promise.all(tags.map(async (tag) => {
        const newTag = await Tag.create({ name: tag, user: req.user.id, notes: [note._id] });
        return newTag._id;
    }));

    // create new todos
    const todoIds = await Promise.all(todos.map(async (todo) => {
        const newTodo = await Todo.create({ name: todo, user: req.user.id, isChecked: false, notes: [note._id] });
        return newTodo._id;
    }));

    // add note id to tags and todos
    await Tag.updateMany({ _id: { $in: tagIds } }, { $push: { notes: note._id } });
    await Todo.updateMany({ _id: { $in: todoIds } }, { $push: { notes: note._id } });

    // add tags and todos to note
    note.tags = tagIds;
    note.todos = todoIds;
    await note.save();

    res.status(200).json(note);
});

// @desc    Update note
// @route   PUT /api/notes
// @access  Private
const updateNote = asyncHandler(async (req, res) => {
    const { title, content, tags, todos } = req.body;
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

    // update tags
    const existingTags = note.tags;
    const newTagIds = [];

    for (const tag of tags) {
        let tagId;
        if(existingTags.includes(tag)) {
            tagId = tag;
        } else {
            const newTag = await Tag.create({ name: tag, user: req.user.id, notes: [note._id] });
            tagId = newTag._id;
        }
        newTagIds.push(tagId);
    }

    note.tags = newTagIds;

    // update todos
    const existingTodos = note.todos;
    const newTodoIds = [];

    for (const todo of todos) {
        let todoId;
        if(existingTodos.includes(todo)) {
            todoId = todo;
        } else {
            const newTodo = await Todo.create({ name: todo, user: req.user.id, isChecked: false, notes: [note._id] });
            todoId = newTodo._id;
        }
        newTodoIds.push(todoId);
    }

    note.todos = newTodoIds;

    await note.save();
    res.status(200).json(note);
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