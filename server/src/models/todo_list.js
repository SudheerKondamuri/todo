const mongoose = require('mongoose');
const todoListSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true
  },
  description: {
    type: String,
    required: false
  },
  createdAt: {
    type: Date,
    default: Date.now
  },
  remainderDate:{
    type: Date,
    required: false
  },
  completionStatus: {
    type: Boolean,
    default: false
  }

});
module.exports = mongoose.model('TodoList', todoListSchema);