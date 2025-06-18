const express = require('express');
const router = express.Router();
const db = require('../db');
const http = require('http');
const https = require('https');
const { StringDecoder } = require('string_decoder');



// router.get('/ai/analysis', async (req, res) => {
//   const { book_id } = req.query; // ✅ 改为 query 获取参数
//   console.log('AI请求参数：', book_id);
//   if (!book_id) {
//     return res.status(400).json({ error: '缺少 book_id 参数' });
//   }

//   try {
//     // 查询数据库获取书名
//     const [rows] = await db.query('SELECT title FROM book WHERE id = ?', [book_id]);

//     if (rows.length === 0) {
//       return res.status(404).json({ error: '未找到对应的图书' });
//     }

//     const bookTitle = rows[0].title;
//     console.log('AI请求参数：', bookTitle);
//     // AI 请求配置
//     const options = {
//       hostname: 'spark-api-open.xf-yun.com',
//       path: '/v1/chat/completions',
//       method: 'POST',
//       headers: {
//         'Authorization': 'Bearer tpOXPjHTkYPWoAZjNXNO:HCHqHABuYdDnERVuayqf',
//         'Content-Type': 'application/json'
//       }
//     };

//     const requestData = JSON.stringify({
//       "max_tokens": 500,
//       "top_k": 2,
//       "temperature": 0.4,
//       "messages": [
//         {
//           "role": "user",
//           "content": `请根据以下图书的标题，生成一段分析内容，包含以下三项信息：
//                   1. 阅读时间（大概需要多久读完这本书）
//                   2. 图书评价（简要说明该书的优点和特色）
//                   3. 适合人群（推荐这本书适合哪些读者阅读）

//                   图书标题：${bookTitle}

//                   请用简洁清晰的语句回答，并按照如下 JSON 格式返回：

//                   {
//                     "readingTime": "（示例：约3小时）",
//                     "evaluation": "（示例：语言优美，情节紧凑）",
//                     "suitableFor": "（示例：适合高中生和文学爱好者）"
//                   }`
//         }
//       ],
//       "model": "lite",
//       "stream": false 
//     });

//     let responseData = '';
//     const decoder = new StringDecoder('utf8');

//     // 创建 HTTPS 请求（注意这里将变量名改为 apiReq 避免冲突）
//     const apiReq = https.request(options, (apiRes) => {
//       apiRes.on('data', (chunk) => {
//         responseData += decoder.write(chunk);
//       });

//       apiRes.on('end', () => {
//         try {
//           const parsedData = JSON.parse(responseData);
          
//           // 假设 AI 返回的数据结构包含所需信息
//           const aiResponse = parsedData.choices[0].message.content;
          
//           // 解析 AI 返回的 JSON 内容
//           const analysis = JSON.parse(aiResponse);
          
//           res.json({
//             bookTitle,
//             ...analysis
//           });
//         } catch (error) {
//           console.error('解析 AI 响应失败:', error);
//           res.status(500).json({ error: '解析 AI 响应失败' });
//         }
//       });
//     });

//     apiReq.on('error', (error) => {
//       console.error('AI 请求出错:', error);
//       res.status(500).json({ error: 'AI 请求失败' });
//     });

//     // 发送请求数据（注意这里的位置正确）
//     apiReq.write(requestData);
//     apiReq.end();
//     return res.json({
//         bookTitle,
//         ...analysis
//       }); // ✅ return 加上
//   } catch (err) {
//     console.error('数据库查询出错:', err);
//     res.status(500).json({ error: '服务器内部错误' });
//   }

// });


router.get('/ai/analysis', async (req, res) => {//搜索图书
  const { book_id } = req.query;
  if (!book_id) {
    return res.status(400).json({ error: '缺少 book_id 参数' });
  }

  try {
    const [rows] = await db.query('SELECT title FROM books WHERE id = ?', [book_id]);
    if (rows.length === 0) {
      return res.status(404).json({ error: '未找到对应的图书' });
    }

    const bookTitle = rows[0].title;
    console.log('书籍名字：', bookTitle);

    const options = {
      hostname: 'spark-api-open.xf-yun.com',
      path: '/v1/chat/completions',
      method: 'POST',
      headers: {
        'Authorization': 'Bearer tpOXPjHTkYPWoAZjNXNO:HCHqHABuYdDnERVuayqf',
        'Content-Type': 'application/json'
      }
    };

    const requestData = JSON.stringify({
      max_tokens: 500,
      top_k: 2,
      temperature: 0.4,
      model: "lite",
      stream: false,
       messages: [
         {
           role: "user",
           content: `请根据以下图书的标题，生成一段分析内容，并返回如下 JSON 格式：
        {
          "readingTime":(以小时为单位,阅读全书所需时间)
          "evaluation": 
          "suitableFor": 
        }
        图书标题：${bookTitle}`
                }
      ]
    });

    let responseData = '';
    const decoder = new StringDecoder('utf8');

    const apiReq = https.request(options, (apiRes) => {
      apiRes.on('data', (chunk) => {
        responseData += decoder.write(chunk);
      });

      apiRes.on('end', () => {
        try {
          const parsedData = JSON.parse(responseData);
           console.log('AI 原始返回内容:', parsedData);
          const aiRawContent = parsedData.choices?.[0]?.message?.content || '';
          // 清洗 Markdown JSON 格式（移除 ```json ```）
          const cleanJson = aiRawContent.replace(/```json|```/g, '').trim();
          const analysis = JSON.parse(cleanJson);
          console.log('解析后的分析内容:', analysis);
          return res.json({
            bookTitle,
            ...analysis
          });
        } catch (err) {
          console.error('解析 AI 响应失败:', err.message);
          if (!res.headersSent) {
            return res.status(500).json({ error: 'AI 响应解析失败' });
          }
        }
      });
    });

    apiReq.on('error', (err) => {
      console.error('AI 请求出错:', err.message);
      if (!res.headersSent) {
        return res.status(500).json({ error: 'AI 请求失败' });
      }
    });

    apiReq.write(requestData);
    apiReq.end();

  } catch (err) {
    console.error('数据库查询出错:', err.message);
    return res.status(500).json({ error: '服务器内部错误' });
  }


});


// controllers/books.js
router.get('/', async (req, res) => {
  const { keyword, title, author, isbn, category, page = 1, pageSize = 10 } = req.query
  const offset = (page - 1) * pageSize

  let sql = 'SELECT * FROM books WHERE 1=1'
  const params = []

  // 新增：支持 keyword 模糊搜索
  if (keyword) {
    sql += ' AND (title LIKE ? OR author LIKE ? OR isbn LIKE ?)'
    params.push(`%${keyword}%`, `%${keyword}%`, `%${keyword}%`)
  }
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

  // 统计总数时也要加上相同的条件
  let countSql = 'SELECT COUNT(*) AS total FROM books WHERE 1=1'
  let countParams = []
  if (keyword) {
    countSql += ' AND (title LIKE ? OR author LIKE ? OR isbn LIKE ?)'
    countParams.push(`%${keyword}%`, `%${keyword}%`, `%${keyword}%`)
  }
  if (title) {
    countSql += ' AND title LIKE ?'
    countParams.push(`%${title}%`)
  }
  if (author) {
    countSql += ' AND author LIKE ?'
    countParams.push(`%${author}%`)
  }
  if (isbn) {
    countSql += ' AND isbn LIKE ?'
    countParams.push(`%${isbn}%`)
  }
  if (category) {
    countSql += ' AND category = ?'
    countParams.push(category)
  }
  const [[{ total }]] = await db.query(countSql, countParams)

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
// 更新一本图书
router.put('/:id', async (req, res) => {
  const { id } = req.params;
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
  if (!isbn || !title || !author || !category || !totalCopies || !availableCopies) {
    return res.status(400).json({ error: '缺少必选字段' });
  }

  // 确保可借数量不超过总数量
  if (availableCopies > totalCopies) {
    return res.status(400).json({ error: '可借数量不能超过总数量' });
  }

  const sql = `
    UPDATE books SET 
      isbn = ?, 
      title = ?, 
      author = ?, 
      category = ?, 
      totalCopies = ?, 
      availableCopies = ?, 
      location = ?, 
      cover = ?, 
      description = ?
    WHERE id = ?;
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
    description,
    id
  ];

  try {
    const [result] = await db.query(sql, params);
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: '未找到该图书' });
    }
    res.json({ message: '更新成功' });
  } catch (err) {
    console.error('更新图书失败:', err);
    res.status(500).json({ error: '更新图书失败' });
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
