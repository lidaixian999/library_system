const express = require('express');
const router = express.Router();
const db = require('../db');


// controllers/books.js
router.get('/', async (req, res) => {
  const { title, author, isbn, category, page = 1, pageSize = 10 } = req.query
  const offset = (page - 1) * pageSize

  let sql = 'SELECT * FROM books WHERE 1=1'
  const params = []

  if (title) {
    sql += ' AND title LIKE ?'
    params.push(`%${title}%`)
  }
  if (author) {
    sql += ' AND author LIKE ?'
    params.push(`%${author}%`)
  }
  if (isbn) {
    sql += ' AND isbn LIKE ?'
    params.push(`%${isbn}%`)
  }
  if (category) {
    sql += ' AND category = ?'
    params.push(category)
  }

  sql += ' LIMIT ? OFFSET ?'
  params.push(parseInt(pageSize), parseInt(offset))

  const [rows] = await db.query(sql, params)

  const [[{ total }]] = await db.query('SELECT COUNT(*) AS total FROM books WHERE 1=1', []) // 可以带相同条件优化

  res.json({ books: rows, total })
})


// 新增一本图书
router.post('/', async (req, res) => {
  const { 
    isbn, 
    title, 
    author, 
    category, 
    totalCopies, 
    availableCopies, 
    location, 
    cover, 
    description 
  } = req.body;

  // 验证必选字段
  if (!isbn || !title || !author || !category || !totalCopies || !availableCopies ) {
    return res.status(400).json({ error: '缺少必选字段' });
  }

  const sql = `
    INSERT INTO books (
      isbn, 
      title, 
      author, 
      category, 
      totalCopies, 
      availableCopies, 
      location, 
      cover, 
      description
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;

  const params = [
    isbn, 
    title, 
    author, 
    category, 
    totalCopies, 
    availableCopies, 
    location, 
    cover, 
    description
  ];
  
  try {
    const result = await db.query(sql, params);
    res.json({ message: '添加成功', id: result.insertId });
  } catch (err) {
    console.error('新增图书失败:', err);
    res.status(500).json({ error: '新增图书失败' });
  }
});
// 删除一本图书
router.delete('/:id', async (req, res) => {
  const { id } = req.params;
  const sql = 'DELETE FROM books WHERE id = ?';

  try {
    const result = await db.query(sql, [id]);
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: '未找到该图书' });
    }
    res.json({ message: '删除成功' });
  } catch (err) {
    console.error('删除图书失败:', err);
    res.status(500).json({ error: '删除图书失败' });
  }
});

// 批量删除图书
router.delete('/', async (req, res) => {
  const { ids } = req.body;
  if (!ids || !Array.isArray(ids) || ids.length === 0) {
    return res.status(400).json({ error: '请提供有效的图书ID列表' });
  }

  const sql = 'DELETE FROM books WHERE id IN (?)';

  try {
    const result = await db.query(sql, [ids]);
    res.json({ message: `成功删除${result.affectedRows}本图书` });
  } catch (err) {
    console.error('批量删除失败:', err);
    res.status(500).json({ error: '批量删除失败' });
  }
});

module.exports = router;
