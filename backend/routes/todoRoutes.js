const express = require('express');
const router = express.Router();
const { protect } = require('../middleware/authMiddleware');
const { getTodos, getTodosOfNote, createTodo, updateTodo, deleteTodo } = require('../controllers/todoController');


router.route('/').get(protect, getTodos).post(protect, createTodo);
router.route('/:id').get(protect, getTodosOfNote).put(protect, updateTodo).delete(protect, deleteTodo);

module.exports = router;
