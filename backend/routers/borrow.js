// routers/borrow.js
const express = require('express');
const router = express.Router();
const db = require('../db');

// 借书
router.post('/borrow', async (req, res) => {
  const { user_id, book_id } = req.body;

  // 检查图书状态
  const [bookRows] = await db.query('SELECT * FROM books WHERE id = ?', [book_id]);
  if (bookRows.length === 0 || bookRows[0].status !== 'available') {
    return res.status(400).json({ error: 'Book not available' });
  }

  // 插入借阅记录
  await db.query(
    'INSERT INTO borrow_records (user_id, book_id) VALUES (?, ?)',
    [user_id, book_id]
  );

  // 修改图书状态为 borrowed
  await db.query('UPDATE books SET status = ? WHERE id = ?', ['borrowed', book_id]);

  res.json({ message: 'Book borrowed' });
});

// 还书
router.post('/return', async (req, res) => {
  const { record_id } = req.body;

  // 查找借书记录
  const [recordRows] = await db.query('SELECT * FROM borrow_records WHERE id = ?', [record_id]);
  if (recordRows.length === 0) {
    return res.status(400).json({ error: 'Record not found' });
  }

  // 设置还书时间
  await db.query('UPDATE borrow_records SET return_time = NOW() WHERE id = ?', [record_id]);

  // 修改图书状态为 available
  const book_id = recordRows[0].book_id;
  await db.query('UPDATE books SET status = ? WHERE id = ?', ['available', book_id]);

  res.json({ message: 'Book returned' });
});

module.exports = router;
