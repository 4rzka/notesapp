const express = require('express');
const router = express.Router();
const { getContacts, postContact, updateContact, deleteContact } = require('../controllers/contactController');
const { protect } = require('../middleware/authMiddleware');

router.route('/').get(protect, getContacts).post(protect, postContact);
router.route('/:id').put(protect, updateContact).delete(protect, deleteContact);

module.exports = router;