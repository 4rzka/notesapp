const asyncHandler = require('express-async-handler');
const Todo = require('../models/todoModel');
const Note = require('../models/noteModel');

// @desc    Get all todos
// @route   GET /api/todos
// @access  Private
const getTodos = asyncHandler(async (req, res) => {
    const todos = await Todo.find({ user: req.user.id });
    res.status(200).json(todos);
}
);

// @desc    Get all todos by note id
// @route   GET /api/todos/:id
// @access  Private
const getTodosOfNote = asyncHandler(async (req, res) => {
    const note = await Note.findById(req.params.id);
    if (note) {
        const todos = await Todo.find({ _id: { $in: note.todos } });
        res.status(200).json(todos);
    } else {
        res.status(404);
        throw new Error('Note not found');
    }
}
);

// @desc    Create a todo
// @route   POST /api/todos
// @access  Private
const createTodo = asyncHandler(async (req, res) => {
    if (!req.body.name) {
        res.status(400);
        throw new Error('Name is required');
    }

    const { name } = req.body;

    const todo = await Todo.create({
        name,
        user: req.user.id
    });

    res.status(200).json(todo);
}
);

// @desc    Update a todo
// @route   PUT /api/todos/:id
// @access  Private
const updateTodo = asyncHandler(async (req, res) => {
    if (!req.body.name) {
        res.status(400);
        throw new Error('Name is required');
    }

    const { name, isChecked } = req.body;

    const todo = await Todo.findById(req.params.id);

    if (todo) {
        todo.name = name || todo.name;
        todo.isChecked = isChecked || todo.isChecked;
        await todo.save();
        res.status(200).json(todo);
    } else {
        res.status(404);
        throw new Error('Todo not found');
    }
}
);

// @desc    Delete a todo
// @route   DELETE /api/todos/:id
// @access  Private
const deleteTodo = asyncHandler(async (req, res) => {
    const todo = await Todo.findById(req.params.id);
    if (todo) {
        await todo.remove();
        res.status(200).json({ message: 'Todo removed' });
    }
    else {
        res.status(404);
        throw new Error('Todo not found');
    }
}
);

module.exports = { getTodos, getTodosOfNote, createTodo, updateTodo, deleteTodo };