const express = require('express');
const { loginUser, addUser, getUsers } = require('../controllers/userController');
const router = express.Router();

router.post('/login', loginUser);
router.post('/add', addUser);
router.get('/', getUsers);

module.exports = router;
