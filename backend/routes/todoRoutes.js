const express = require('express');
const router = express.Router();
const { protect } = require('../middleware/authMiddleware');
const { getTodos, getTodosOfNote, createTodo, updateTodo, deleteTodo, getTodoById } = require('../controllers/todoController');


router.route('/').get(protect, getTodos).post(protect, createTodo);
router.route('/:id').get(protect, getTodoById).put(protect, updateTodo).delete(protect, deleteTodo);
router.route('/note/:id').get(protect, getTodosOfNote);

module.exports = router;
