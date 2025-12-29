const router = require('express').Router();
const {getTodoLists, createTodoList, updateTodoList, deleteTodoList}  = require('../controller/todo_lists.js');
router.get('/api/todo-lists', getTodoLists);
router.post('/api/todo-lists', createTodoList);
router.put('/api/todo-lists/:id', updateTodoList);
router.delete('/api/todo-lists/:id', deleteTodoList);
module.exports = router;