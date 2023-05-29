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

// @desc    Get todo by id
// @route   GET /api/todos/:id
// @access  Private
const getTodoById = asyncHandler(async (req, res) => {
    const todo = await Todo.findById(req.params.id);
    if (todo) {
        res.status(200).json(todo);
    } else {
        res.status(404);
        throw new Error('Todo not found');
    }
}
);


// @desc    Get all todos by note id
// @route   GET /api/todos/note/:id
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

    // add todo id to note
    const note = await Note.findById(req.params.id);
    if (note) {
        note.todos.push(todo._id);
        await note.save();
    } else {
        res.status(404);
        throw new Error('Note not found');
    }
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
    const note = await Note.findById(req.params.noteid);

    if (todo) {
        todo.name = name || todo.name;
        todo.isChecked = isChecked || todo.isChecked;
        note.todos.push(todo._id);
        await todo.save();
        await note.save();
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
    if (!todo) {
        res.status(404);
        throw new Error('Todo not found');
    }

    if (todo.user.toString() !== req.user.id) {
        res.status(401);
        throw new Error('Not authorized to delete tag');
    }

      // remove todo from associated notes
    if (todo.notes && todo.notes.length > 0) {
        await Note.updateMany(
            { _id: { $in: todo.notes }, user: req.user.id },
            { $pull: { todos: todo._id } }
        );
    }

    await Todo.findByIdAndDelete(req.params.id);
    res.status(200).json({ message: 'Todo removed' });
});

module.exports = { getTodos, getTodosOfNote, createTodo, updateTodo, deleteTodo, getTodoById };