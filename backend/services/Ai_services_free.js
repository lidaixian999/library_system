const http = require('http');
const https = require('https');
const { StringDecoder } = require('string_decoder');

const decoder = new StringDecoder('utf8');

// 请求配置
const options = {
  hostname: 'spark-api-open.xf-yun.com',
  path: '/v1/chat/completions',
  method: 'POST',
  headers: {
    'Authorization': 'Bearer tpOXPjHTkYPWoAZjNXNO:HCHqHABuYdDnERVuayqf',
    'Content-Type': 'application/json'
  }
};

// 请求数据
const requestData = JSON.stringify({
  "max_tokens": 1601,
  "top_k": 3,
  "temperature": 0.5,
  "messages": [
    {
      "role": "user",
      "content": "你是一位书籍查询助手,目标任务,请根据我给出的书籍名称，提供书籍大概阅读时间，推荐指数，推荐阅读人群.书籍名字为《了不起的盖茨比》"
    }
    // "role": "system",
    // "content": "你是一位书籍查询助手,目标任务,请根据我给出的书籍名称，提供书籍大概阅读时间，推荐指数，推荐阅读人群.书籍名字为《了不起的盖茨比》"
  ],
  "model": "lite",
  "stream": true
});

// 创建请求
const req = https.request(options, (res) => {
  console.log(`状态码: ${res.statusCode}`);
  
  // 处理流式响应
  res.on('data', (chunk) => {
    const lines = decoder.write(chunk).split('\n');
    lines.forEach(line => {
      if (line.trim()) {
        console.log(line);
      }
    });
  });
  
  res.on('end', () => {
    console.log('流响应结束');
  });
});

// 错误处理
req.on('error', (error) => {
  console.error('请求出错:', error);
});

// 发送请求数据
req.write(requestData);
req.end();