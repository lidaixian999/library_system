# 图书管理系统技术文档
演示视频图书管理系统.mp4
链接: https://pan.baidu.com/s/1gVsSftBG0hpznk9BfQ4JmA?pwd=nx3k

## 📋 项目概述

本项目是一个基于 Vue.js + Node.js 的全栈图书管理系统，旨在为学校图书馆提供完整的图书借阅管理解决方案。系统分为用户端和管理员端，支持图书查询、借阅、归还、用户管理等核心功能。

### 🎯 项目目标
- 学习前后端分离开发模式
- 掌握现代Web开发技术栈
- 实现完整的CRUD操作
- 构建用户友好的界面

## 🏗️ 系统架构

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   前端 (Vue3)    │────│  后端 (Node.js) │────│  数据库 (MySQL) │
│                 │    │                 │    │                 │
│ • Element Plus  │    │ • Express.js   │    │ • 用户表        │
│ • Vue Router    │    │ • MySQL2        │    │ • 图书表        │
│ • Axios         │    │ • bcrypt        │    │ • 借阅记录表    │
│ • Vite          │    │ • CORS          │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🛠️ 技术栈

### 前端技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| Vue.js | 3.5.13 | 前端框架 |
| Element Plus | 2.9.10 | UI组件库 |
| Vue Router | 4.5.1 | 路由管理 |
| Axios | 1.9.0 | HTTP客户端 |
| Vite | 6.2.4 | 构建工具 |
| date-fns | 4.1.0 | 日期处理 |

### 后端技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| Node.js | - | 运行环境 |
| Express.js | 5.1.0 | Web框架 |
| MySQL2 | 3.14.1 | 数据库驱动 |
| bcrypt | 6.0.0 | 密码加密 |
| CORS | 2.8.5 | 跨域处理 |

### 数据库

| 技术 | 用途 |
|------|------|
| MySQL | 关系型数据库 |

## 📁 项目结构

```
library_system/
├── backend/                    # 后端代码
│   ├── routers/               # 路由模块
│   │   ├── books.js          # 图书相关路由
│   │   ├── users.js          # 用户相关路由
│   │   └── borrow.js         # 借阅相关路由
│   ├── servicers/            # 服务层
│   │   ├── Ai_services_free.js
│   │   └── Aiservices.js
│   ├── server.js             # 服务器入口
│   ├── db.js                 # 数据库配置
│   └── package.json          # 依赖配置
├── frontend/                  # 前端代码
│   ├── src/
│   │   ├── views/            # 页面组件
│   │   │   ├── admin/        # 管理员页面
│   │   │   └── user/         # 用户页面
│   │   ├── components/       # 公共组件
│   │   ├── router/           # 路由配置
│   │   ├── utils/            # 工具函数
│   │   ├── App.vue           # 根组件
│   │   └── main.js           # 入口文件
│   ├── public/               # 静态资源
│   ├── package.json          # 依赖配置
│   └── vite.config.js        # 构建配置
├── dump-1-202505181411.sql   # 数据库备份
└── README.md                 # 项目说明
```

## 🗄️ 数据库设计

### 用户表 (users)

| 字段 | 类型 | 说明 | 约束 |
|------|------|------|------|
| id | INT | 用户ID | 主键，自增 |
| username | VARCHAR(50) | 用户名 | 唯一，非空 |
| password | VARCHAR(255) | 密码(加密) | 非空 |
| email | VARCHAR(100) | 邮箱 | 唯一 |
| role | ENUM | 角色 | 'user', 'admin' |
| created_at | TIMESTAMP | 创建时间 | 默认当前时间 |

### 图书表 (books)

| 字段 | 类型 | 说明 | 约束 |
|------|------|------|------|
| id | INT | 图书ID | 主键，自增 |
| title | VARCHAR(200) | 书名 | 非空 |
| author | VARCHAR(100) | 作者 | 非空 |
| isbn | VARCHAR(20) | ISBN | 唯一 |
| category | VARCHAR(50) | 分类 | - |
| total_copies | INT | 总数量 | 默认1 |
| available_copies | INT | 可借数量 | 默认1 |
| created_at | TIMESTAMP | 创建时间 | 默认当前时间 |

### 借阅记录表 (borrow)

| 字段 | 类型 | 说明 | 约束 |
|------|------|------|------|
| id | INT | 记录ID | 主键，自增 |
| user_id | INT | 用户ID | 外键 |
| book_id | INT | 图书ID | 外键 |
| borrow_date | TIMESTAMP | 借阅时间 | 默认当前时间 |
| return_date | TIMESTAMP | 归还时间 | 可空 |
| due_date | TIMESTAMP | 应还时间 | 非空 |
| status | ENUM | 状态 | 'borrowed', 'returned' |

## 🔌 API 接口文档

### 用户相关接口

#### 用户注册
```http
POST /api/users/register
Content-Type: application/json

{
  "username": "string",
  "password": "string",
  "email": "string"
}
```

**响应示例：**
```json
{
  "message": "Registered successfully"
}
```

#### 用户登录
```http
POST /api/users/login
Content-Type: application/json

{
  "username": "string",
  "password": "string"
}
```

**响应示例：**
```json
{
  "message": "Login successful",
  "user": {
    "id": 1,
    "username": "testuser",
    "role": "user"
  }
}
```

#### 修改密码
```http
POST /api/users/change-password
Content-Type: application/json

{
  "username": "string",
  "newPassword": "string"
}
```

### 图书相关接口

#### 获取图书列表
```http
GET /api/books
```

#### 添加图书
```http
POST /api/books
Content-Type: application/json

{
  "title": "string",
  "author": "string",
  "isbn": "string",
  "category": "string",
  "total_copies": "number"
}
```

#### 更新图书信息
```http
PUT /api/books/:id
Content-Type: application/json

{
  "title": "string",
  "author": "string",
  "category": "string"
}
```

#### 删除图书
```http
DELETE /api/books/:id
```

### 借阅相关接口

#### 借书
```http
POST /api/borrow/borrow
Content-Type: application/json

{
  "user_id": "number",
  "book_id": "number"
}
```

#### 还书
```http
POST /api/borrow/return
Content-Type: application/json

{
  "user_id": "number",
  "book_id": "number"
}
```

#### 获取借阅记录
```http
GET /api/borrow/records?user_id=1
```

## 🎨 前端架构设计

### 路由设计

```javascript
// 路由配置示例
const routes = [
  { path: '/', redirect: '/login' },
  { path: '/login', component: Login },
  { path: '/register', component: Register },
  
  // 管理员路由
  { path: '/home_controller', component: Home_controller },
  { path: '/library_controller', component: Library_controller },
  { path: '/resources_admin', component: Resources_admin },
  
  // 用户路由
  { path: '/home_user', component: Home_user },
  { path: '/library_user', component: Library_user },
  { path: '/borrow_user', component: Borrow_user }
]
```

### 组件结构

```
components/
├── common/              # 公共组件
│   ├── Header.vue      # 头部导航
│   ├── Footer.vue      # 底部信息
│   └── Loading.vue     # 加载组件
├── admin/              # 管理员组件
│   ├── BookManager.vue # 图书管理
│   ├── UserManager.vue # 用户管理
│   └── Dashboard.vue   # 仪表盘
└── user/               # 用户组件
    ├── BookList.vue    # 图书列表
    ├── BorrowHistory.vue # 借阅历史
    └── Profile.vue     # 个人信息
```

### 状态管理

项目使用 Vue 3 的 Composition API 进行状态管理，主要包括：

- 用户认证状态
- 图书列表数据
- 借阅记录数据
- 全局加载状态

## 🔒 安全设计

### 密码安全
- 使用 bcrypt 进行密码哈希
- 加盐强度设置为 10
- 前端不存储明文密码

### 数据库安全
- 使用参数化查询防止 SQL 注入
- 事务处理确保数据一致性
- 数据库连接池管理

### 跨域处理
- 配置 CORS 中间件
- 限制允许的请求来源

## 🚀 部署指南

### 环境要求

- Node.js >= 16.0.0
- MySQL >= 8.0
- npm >= 8.0.0

### 后端部署

1. **安装依赖**
```bash
cd backend
npm install
```

2. **配置数据库**
```javascript
// db.js
const pool = mysql.createPool({
  host: 'localhost',
  user: 'your_username',
  password: 'your_password',
  database: 'library_system'
});
```

3. **导入数据库**
```bash
mysql -u root -p library_system < dump-1-202505181411.sql
```

4. **启动服务**
```bash
node server.js
```

### 前端部署

1. **安装依赖**
```bash
cd frontend
npm install
```

2. **开发环境**
```bash
npm run dev
```

3. **生产构建**
```bash
npm run build
```

4. **预览构建结果**
```bash
npm run preview
```

### Docker 部署（推荐）

```dockerfile
# Dockerfile.backend
FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8989
CMD ["node", "server.js"]
```

```dockerfile
# Dockerfile.frontend
FROM node:16-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
```

## 🧪 测试策略

### 后端测试
- 单元测试：使用 Jest 测试业务逻辑
- 集成测试：测试 API 接口
- 数据库测试：测试数据操作

### 前端测试
- 组件测试：使用 Vue Test Utils
- E2E 测试：使用 Cypress
- 用户交互测试

## 📈 性能优化

### 前端优化
- 路由懒加载
- 组件按需引入
- 图片懒加载
- 代码分割

### 后端优化
- 数据库连接池
- 查询优化
- 缓存策略
- 接口限流

## 🐛 常见问题

### 数据库连接问题
```bash
# 检查MySQL服务状态
sudo systemctl status mysql

# 重启MySQL服务
sudo systemctl restart mysql
```

### 跨域问题
确保后端正确配置 CORS：
```javascript
app.use(cors({
  origin: 'http://localhost:5173',
  credentials: true
}));
```

### 端口冲突
修改配置文件中的端口号：
- 后端：server.js 中的 port 变量
- 前端：vite.config.js 中的 server.port

## 📚 学习资源

### 官方文档
- [Vue.js 官方文档](https://vuejs.org/)
- [Element Plus 文档](https://element-plus.org/)
- [Express.js 文档](https://expressjs.com/)
- [MySQL 文档](https://dev.mysql.com/doc/)

### 推荐教程
- Vue 3 + Vite 快速上手
- Node.js + Express 后端开发
- MySQL 数据库设计
- 前后端分离项目实战

## 🤝 贡献指南

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 📞 联系方式

- 项目维护者：[您的姓名]
- 邮箱：[您的邮箱]
- 项目地址：[GitHub仓库地址]

---

**注意：** 本项目以学习前后端开发为主要目的，持续更新中，如有缺陷多多包涵。

*最后更新时间：2024年12月*
