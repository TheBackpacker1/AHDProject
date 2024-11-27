const User = require('../models/User');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

const loginUser = async (req, res) => {
  const { email, password } = req.body;
  const user = await User.findOne({ email });

  if (user && (await bcrypt.compare(password, user.password))) {
    const token = jwt.sign({ id: user._id, role: user.role }, process.env.JWT_SECRET, {
      expiresIn: '30d',
    });
    res.json({ id: user._id, role: user.role, token });
  } else {
    res.status(401).json({ message: 'Invalid credentials' });
  }
};

const addUser = async (req, res) => {
  const { name, lastName, email, password, role } = req.body;

  try {
    const user = new User({ name, lastName, email, password, role });
    await user.save();
    res.status(201).json({ message: 'User added successfully' });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

const getUsers = async (req, res) => {
  const users = await User.find();
  res.json(users);
};

module.exports = { loginUser, addUser, getUsers };
