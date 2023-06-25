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
    // added "sharedto" into note model so that we can get notes that are shared to the user
    const sharedNotes = await Note.find({ sharedto: req.user.id });
    notes.push(...sharedNotes);
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

    const { title, content, tags, todos, contacts } = req.body;

    // create the note without tags and todos so that we can get the note id to add to tags and todos
    const note = await Note.create({
        title,
        content,
        contacts,
        user: req.user.id
    });

    // create new tag if tag is provided in the request but not in the database
    // if user does not provide any tags, then tagIds will be an empty array
    if (!tags) {
        tags = [];
    }
    const tagIds = await Promise.all(tags.map(async (tag) => {
        const newTag = await Tag.create({ name: tag, user: req.user.id, notes: [note._id] });
        return newTag._id;
    }));

    // add note id to tags and todos
    await Tag.updateMany({ _id: { $in: tagIds } }, { $push: { notes: note._id } });

    // add tags and todos to note
    note.tags = tagIds;
    // note.todos = todoIds;
    note.todos = todos;
    await note.save();

    res.status(200).json(note);
});

// @desc    Update note
// @route   PUT /api/notes
// @access  Private
const updateNote = asyncHandler(async (req, res) => {
    let { title, content, tags, todos, sharedto, contacts } = req.body;
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

    // update tags if tags are provided in the request body and if the tags are not already in the note
    const existingTags = note.tags;
    const newTagIds = [];
    if (!tags) {
        tags = [];
    }
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

    // update todos if todos are provided in the request body and if the todos are not already in the note
    const existingTodos = note.todos;
    const newTodoIds = [];
    if (!todos) {
        todos = [];
    }
    for (const todo of todos) {
        let todoId;
        const todoName = todo.name;
        const existingTodo = existingTodos.find(t => t.name === todoName); 
    
        if (existingTodo) {
            todoId = existingTodo._id; 
        } else {
            const newTodo = await Todo.create({ name: todoName, user: req.user.id, isChecked: false, notes: [note._id] });
            todoId = newTodo._id;
        }
        newTodoIds.push(todoId);
    }

    note.todos = newTodoIds;

    // Sharedto is an array of user emails
    // We need to find the user ids of the users with the emails in sharedto
    // Then we add the user ids to the sharedto field of the note
    const sharedtoUserIds = [];
    if (!sharedto) {
        sharedto = [];
    }
    for (const email of sharedto) {
        const user = await User.findOne({ email });
        if(!user) {
            res.status(404);
            throw new Error(`User with email ${email} not found`);
        }
        sharedtoUserIds.push(user._id);
    }
    
    note.sharedto = sharedtoUserIds;

    note.title = title || note.title;
    note.content = content || note.content;
    note.contacts = contacts || note.contacts;

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