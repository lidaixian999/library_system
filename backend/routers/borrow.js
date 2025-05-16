// routers/borrow.js
const express = require('express');
const router = express.Router();
const db = require('../db');

// 借书接口
router.post('/borrow', async (req, res) => {
  const { user_id, book_id } = req.body;

  try {
    await db.query('START TRANSACTION');

    // 检查图书状态和库存
    const [bookRows] = await db.query(
      'SELECT * FROM books WHERE id = ? FOR UPDATE',
      [book_id]
    );

    if (bookRows.length === 0) {
      await db.query('ROLLBACK');
      return res.status(404).json({ error: '图书不存在' });
    }

    const book = bookRows[0];
    if (book.available_copies <= 0) {
      await db.query('ROLLBACK');
      return res.status(400).json({ error: '图书库存不足' });
    }

    // 检查用户是否已借阅此书
    const [borrowCheck] = await db.query(
      'SELECT * FROM borrow WHERE user_id = ? AND book_id = ? AND status = "borrowed"',
      [user_id, book_id]
    );

    if (borrowCheck.length > 0) {
      await db.query('ROLLBACK');
      return res.status(400).json({ error: '您已借阅过此书' });
    }

    // 插入借阅记录
    await db.query(`
      INSERT INTO borrow (
        user_id, 
        book_id, 
        borrow_date, 
        due_date,
        status
      ) VALUES (
        ?, 
        ?, 
        NOW(), 
        DATE_ADD(NOW(), INTERVAL 30 DAY),
        'borrowed'
      )`,
      [user_id, book_id]
    );

    // 更新图书库存
    await db.query(`
      UPDATE books 
      SET availableCopies = availableCopies - 1 
      WHERE id = ?`,
      [book_id]
    );

    await db.query('COMMIT');
    res.json({ message: '借阅成功' });
  } catch (error) {
    await db.query('ROLLBACK');
    console.error('借阅失败:', error);
    res.status(500).json({ error: '借阅失败' });
  }
});

// 获取借阅列表
router.get('/list', async (req, res) => {
  const { username } = req.query;
  try {
    const [userRows] = await db.query('SELECT id FROM users WHERE username = ?', [username]);
    if (userRows.length === 0) {
      return res.status(404).json({ error: '用户不存在' });
    }
    const userId = userRows[0].id;

    // 查询当前借阅
    const [currentBorrows] = await db.query(`
      SELECT 
        b.title as bookName,
        b.isbn as bookId,
        br.borrow_date as borrowDate,
        br.due_date as dueDate,
        br.id as recordId,
        br.status
      FROM borrow br
      JOIN books b ON br.book_id = b.id
      WHERE br.user_id = ? AND br.status = 'borrowed'
    `, [userId]);

    // 查询借阅历史
    const [borrowHistory] = await db.query(`
      SELECT 
        b.title as bookName,
        b.isbn as bookId,
        br.borrow_date as borrowDate,
        br.return_date as returnDate,
        br.status
      FROM borrow br
      JOIN books b ON br.book_id = b.id
      WHERE br.user_id = ? AND br.status = 'returned'
    `, [userId]);

    res.json({
      current: currentBorrows,
      history: borrowHistory
    });
  } catch (error) {
    console.error('获取借阅记录失败:', error);
    res.status(500).json({ error: '获取借阅记录失败' });
  }
});

// 续借接口
router.post('/renew', async (req, res) => {
  const { recordId } = req.body;
  try {
    const [record] = await db.query('SELECT * FROM borrow WHERE id = ? AND status = "borrowed"', [recordId]);
    if (!record.length) {
      return res.status(400).json({ error: '该记录不存在或已归还' });
    }

    await db.query(`
      UPDATE borrow 
      SET due_date = DATE_ADD(due_date, INTERVAL 14 DAY)
      WHERE id = ?
    `, [recordId]);

    res.json({ message: '续借成功' });
  } catch (error) {
    res.status(500).json({ error: '续借失败' });
  }
});

// 还书接口
router.post('/return', async (req, res) => {
  const { record_id } = req.body;

  try {
    await db.query('START TRANSACTION');

    const [record] = await db.query('SELECT * FROM borrow WHERE id = ? AND status = "borrowed"', [record_id]);
    if (!record.length) {
      await db.query('ROLLBACK');
      return res.status(400).json({ error: '借阅记录不存在或已归还' });
    }

    // 更新借阅记录
    await db.query(`
      UPDATE borrow 
      SET return_date = NOW(),
          status = 'returned'
      WHERE id = ?
    `, [record_id]);

    // 更新图书库存
    await db.query(`
      UPDATE books 
      SET availableCopies = availableCopies + 1
      WHERE id = ?
    `, [record[0].book_id]);

    await db.query('COMMIT');
    res.json({ message: '归还成功' });
  } catch (error) {
    await db.query('ROLLBACK');
    console.error('归还失败:', error);
    res.status(500).json({ error: '归还失败' });
  }
});

module.exports = router;
