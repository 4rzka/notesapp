const express = require('express');
const router = express.Router();
const { getNotes, postNote, updateNote, deleteNote } = require('../controllers/noteController');

router.route('/').get(getNotes).post(postNote);
router.route('/:id').put(updateNote).delete(deleteNote);

module.exports = router;