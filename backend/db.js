// db.js
const mysql = require('mysql2');

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '@Lmj20041114',
  database: 'library_system',
});

// 使用 promise API
module.exports = pool.promise();
