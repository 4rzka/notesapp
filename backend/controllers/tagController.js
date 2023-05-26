const asyncHandler = require('express-async-handler');
const Tag = require('../models/tagModel');
const Note = require('../models/noteModel');

// @desc    Get all tags
// @route   GET /api/tags
// @access  Private
const getTags = asyncHandler(async (req, res) => {
  const tags = await Tag.find({ user: req.user.id });
  res.status(200).json(tags);
});

// @desc    Create a tag
// @route   POST /api/tags
// @access  Private
const createTag = asyncHandler(async (req, res) => {
  const { name, notes } = req.body;
  // check if tag already exists
  const tagExists = await Tag.findOne({ name, user: req.user.id });
  if (tagExists) {
    res.status(400);
    throw new Error('Tag already exists');
  }
  const tag = await Tag.create({ name, user: req.user.id, notes });

  // add tag to notes
  if (notes && notes.length > 0) {
    await Note.updateMany(
      { _id: { $in: notes }, user: req.user.id },
      { $addToSet: { tags: tag._id } }
    );
  }

  res.status(201).json(tag);
});

// @desc    Update a tag
// @route   PUT /api/tags/:id
// @access  Private
const updateTag = asyncHandler(async (req, res) => {
  const { name, notes } = req.body;

  const tag = await Tag.findById(req.params.id);
  if (!tag) {
    res.status(404);
    throw new Error('Tag not found');
  }

  if (tag.user.toString() !== req.user.id) {
    res.status(401);
    throw new Error('Not authorized to update tag');
  }

  const updatedTag = await Tag.findByIdAndUpdate(
    req.params.id,
    { name, notes },
    { new: true }
  );

  // update notes with new tag id
  if (notes && notes.length > 0) {
    await Note.updateMany(
      { _id: { $in: notes }, user: req.user.id },
      { $addToSet: { tags: updatedTag._id } }
    );
  }

  // remove tag from notes that are no longer associated with it
  const removedNotes = tag.notes.filter(
    (note) => !notes.includes(note.toString())
  );
  if (removedNotes.length > 0) {
    await Note.updateMany(
      { _id: { $in: removedNotes }, user: req.user.id },
      { $pull: { tags: updatedTag._id } }
    );
  }

  res.status(200).json(updatedTag);
});

// @desc    Delete a tag
// @route   DELETE /api/tags/:id
// @access  Private
const deleteTag = asyncHandler(async (req, res) => {
  const tag = await Tag.findById(req.params.id);
  if (!tag) {
    res.status(404);
    throw new Error('Tag not found');
  }

  if (tag.user.toString() !== req.user.id) {
    res.status(401);
    throw new Error('Not authorized to delete tag');
  }

  // remove tag from associated notes
  if (tag.notes && tag.notes.length > 0) {
    await Note.updateMany(
      { _id: { $in: tag.notes }, user: req.user.id },
      { $pull: { tags: tag._id } }
    );
  }

  await Tag.findByIdAndDelete(req.params.id);
  res.status(200).json({ message: 'Tag removed' });
});

module.exports = {
  getTags,
  createTag,
  updateTag,
  deleteTag,
};