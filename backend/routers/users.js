const express = require('express');
const bcrypt = require('bcrypt');
const db = require('../db');
const router = express.Router();

// 注册接口
router.post('/register', async (req, res) => {
  const { username, password } = req.body;
  const [rows] = await db.query('SELECT * FROM users WHERE username = ?', [username]);
  if (rows.length > 0) {
    return res.status(400).json({ error: 'Username already exists' });
  }

  const hashedPassword = await bcrypt.hash(password, 10); // 10是加盐强度
  await db.query('INSERT INTO users (username, password) VALUES (?, ?)', [username, hashedPassword]);

  res.json({ message: 'Registered successfully' });
});

// 登录接口
router.post('/login', async (req, res) => {
  const { username, password } = req.body;

  const [rows] = await db.query('SELECT * FROM users WHERE username = ?', [username]);
  if (rows.length === 0) {
    return res.status(401).json({ error: 'Invalid credentials' });
  }

  const user = rows[0];
  const isPasswordValid = await bcrypt.compare(password, user.password); // 验证密码

  if (!isPasswordValid) {
    return res.status(401).json({ error: 'Invalid credentials' });
  }

  res.json({ message: 'Login success', user: { id: user.id, username: user.username } });
});

module.exports = router; 