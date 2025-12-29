const TodoList = require('../../models/todo_list.js');
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
exports.updateTodoList = async (req, res) => {
  try {
    const todoList = await TodoList.findById(req.params.id);
    if (!todoList) {
      return res.status(404).json({ message: 'Todo list not found' });
    }       
    todoList.title = req.body.title;
    todoList.description = req.body.description;
    todoList.remainderDate = req.body.remainderDate;
    todoList.completionStatus = req.body.completionStatus;
    const updatedTodoList = await todoList.save();
    res.json(updatedTodoList);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
exports.deleteTodoList = async (req, res) => {
  try {
    const todoList = await TodoList.findById(req.params.id);
    if (!todoList) {
      return res.status(404).json({ message: 'Todo list not found' });
    }
    await todoList.remove();
    res.json({ message: 'Todo list deleted' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

