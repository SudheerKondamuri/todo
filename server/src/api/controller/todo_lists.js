import { removeAllListeners } from '../../../models/todo_list_model.js';
import TodoList from '../model/todo_list.js';
exports.getTodoLists = async (req, res) => {
  try {
    const todoLists = await TodoList.find();
    res.json(todoLists);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.createTodoList = async (req, res) => {
  const todoList = new TodoList({
    title: req.body.title,
    description: req.body.description,
    remainderDate: req.body.remainderDate,
    completionStatus: req.body.completionStatus
  });

  try {
    const newTodoList = await todoList.save();
    res.status(201).json(newTodoList);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};
exports.deleteAllTodoLists = async (req, res) => {
  try {
    const result = await TodoList.deleteMany({});
    res.status(200).json({ message: `${result.deletedCount} todo lists deleted.` });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

