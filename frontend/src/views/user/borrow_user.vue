<template>
    <div class="borrow-container">
      <!-- 顶部导航栏 -->
      <header class="header">
        <div class="logo">
          <img src="@/assets/photo/sztu-logo.jpg" alt="深技大logo">
          <span>深圳技术大学</span>
        </div>
        <nav class="nav">
          <el-menu
            mode="horizontal"
            :default-active="activeIndex"
            @select="handleSelect"
          >
            <el-menu-item index="1">首页</el-menu-item>
            <el-menu-item index="2">图书馆</el-menu-item>
            <el-menu-item index="3">教学资源</el-menu-item>
            <el-menu-item index="4">校园生活</el-menu-item>
            <el-menu-item index="5">关于我们</el-menu-item>
          </el-menu>
        </nav>
        <div class="user-info">
          <el-dropdown>
            <span class="el-dropdown-link">
              <el-avatar :size="40" :src="userAvatarref" />
              <span class="username">用户</span>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item>个人中心</el-dropdown-item>
                <el-dropdown-item>系统设置</el-dropdown-item>
                <el-dropdown-item divided @click="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </header>
  
      <!-- 主要内容区 -->
      <main class="main-content">
        <div class="page-header">
          <h1>我的借阅</h1>
          <el-button type="primary" @click="goBack">返回首页</el-button>
        </div>
  
        <el-tabs v-model="activeTab" class="borrow-tabs">
          <el-tab-pane label="当前借阅" name="current">
            <el-table :data="currentBorrows" style="width: 100%">
              <el-table-column prop="bookName" label="图书名称" width="200" />
              <el-table-column prop="bookId" label="图书编号" width="120" />
              <el-table-column prop="borrowDate" label="借出日期" width="150" />
              <el-table-column prop="dueDate" label="应还日期" width="150" />
              <el-table-column prop="status" label="状态" width="100">
                <template #default="scope">
                  <el-tag :type="scope.row.status === '正常' ? 'success' : 'danger'">
                    {{ scope.row.status }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="操作" width="150">
                <template #default="scope">
                  <el-button size="small" @click="handleRenew(scope.row)">续借</el-button>
                  <el-button size="small" type="danger" @click="handleReturn(scope.row)">归还</el-button>
                </template>
              </el-table-column>
            </el-table>
          </el-tab-pane>
  
          <el-tab-pane label="借阅历史" name="history">
            <el-table :data="borrowHistory" style="width: 100%">
              <el-table-column prop="bookName" label="图书名称" width="200" />
              <el-table-column prop="bookId" label="图书编号" width="120" />
              <el-table-column prop="borrowDate" label="借出日期" width="150" />
              <el-table-column prop="returnDate" label="归还日期" width="150" />
              <el-table-column prop="status" label="状态" width="100">
                <template #default="scope">
                  <el-tag :type="scope.row.status === '已归还' ? 'success' : 'danger'">
                    {{ scope.row.status }}
                  </el-tag>
                </template>
              </el-table-column>
            </el-table>
          </el-tab-pane>
        </el-tabs>
      </main>
  
      <!-- 页脚 -->
      <footer class="footer">
        <div class="footer-content">
          <div class="footer-section">
            <h3>关于我们</h3>
            <p>深圳技术大学是深圳市的一所公立应用技术型大学</p>
          </div>
          <div class="footer-section">
            <h3>联系方式</h3>
            <p>电话: </p>
            <p>邮箱: @sztu.edu.cn</p>
          </div>
          <div class="footer-section">
            <h3>相关链接</h3>
            <el-link type="info" href="https://www.sztu.edu.cn" target="_blank">学校官网</el-link>
            <el-link type="info" href="https://lib.sztu.edu.cn" target="_blank">图书馆</el-link>
          </div>
        </div>
        <div class="copyright">
          <p>© 2025 216 版权所有</p>
        </div>
      </footer>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue'
  import { useRouter } from 'vue-router'
  import userAvatar from '@/assets/photo/user.png'
  
  const router = useRouter()
  
  // 导航菜单
  const activeIndex = ref('2')
  const handleSelect = (key) => {
    console.log('选中菜单:', key)
  }
  
  // 用户头像
  const userAvatarref = ref(userAvatar)
  
  // 借阅数据
  const activeTab = ref('current')
  const currentBorrows = ref([
    {
      bookName: 'Vue.js设计与实现',
      bookId: 'TP312V/123',
      borrowDate: '2023-10-15',
      dueDate: '2023-11-15',
      status: '正常'
    },
    {
      bookName: 'JavaScript高级程序设计',
      bookId: 'TP312JS/456',
      borrowDate: '2023-10-10',
      dueDate: '2023-11-10',
      status: '即将到期'
    },
    {
      bookName: '深入浅出Node.js',
      bookId: 'TP312N/789',
      borrowDate: '2023-09-20',
      dueDate: '2023-10-20',
      status: '已逾期'
    }
  ])
  
  const borrowHistory = ref([
    {
      bookName: 'CSS权威指南',
      bookId: 'TP312C/101',
      borrowDate: '2023-08-01',
      returnDate: '2023-08-30',
      status: '已归还'
    },
    {
      bookName: 'HTML5权威指南',
      bookId: 'TP312H/202',
      borrowDate: '2023-07-15',
      returnDate: '2023-08-15',
      status: '已归还'
    }
  ])
  
  // 操作方法
  const handleRenew = (row) => {
    ElMessage.success(`已续借图书: ${row.bookName}`)
    // 实际应用中这里应该调用续借API
  }
  
  const handleReturn = (row) => {
    ElMessage.success(`已归还图书: ${row.bookName}`)
    // 实际应用中这里应该调用归还API
  }
  
  const goBack = () => {
    router.push('/Home_user')
  }
  
  const logout = () => {
    router.push('/login')
  }
  </script>
  
  <style scoped>
  .borrow-container {
    width: 100vw;
    height: 100vh;
    overflow: auto;
    display: flex;
    flex-direction: column;
    background-color: #fff;
  }
  
  /* 顶部导航栏样式 */
  .header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 20px;
    height: 60px;
    background-color: #fff;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    z-index: 100;
    flex: 0 0 auto;
  }
  
  .logo {
    display: flex;
    align-items: center;
    font-size: 18px;
    font-weight: bold;
    color: #303133;
  }
  
  .logo img {
    height: 40px;
    margin-right: 10px;
  }
  
  .nav {
    flex: 1;
    margin: 0 20px;
  }
  
  .user-info {
    display: flex;
    align-items: center;
  }
  
  .username {
    margin-left: 10px;
    font-size: 14px;
  }
  
  /* 主要内容区样式 */
  .main-content {
    flex: 1;
    padding: 20px;
    max-width: 1200px;
    margin: 0 auto;
    width: 100%;
  }
  
  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
  }
  
  .borrow-tabs {
    margin-top: 20px;
  }
  
  /* 页脚样式 */
  .footer {
    background-color: #303133;
    color: #fff;
    padding: 30px 0 0;
  }
  
  .footer-content {
    display: flex;
    justify-content: space-around;
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
  }
  
  .footer-section {
    flex: 1;
    padding: 0 20px;
  }
  
  .footer-section h3 {
    font-size: 16px;
    margin-bottom: 15px;
  }
  
  .footer-section p {
    font-size: 14px;
    color: #c0c4cc;
    margin-bottom: 10px;
  }
  
  .copyright {
    text-align: center;
    padding: 20px 0;
    border-top: 1px solid #434343;
    font-size: 14px;
    color: #c0c4cc;
  }
  
  /* 响应式设计 */
  @media (max-width: 768px) {
    .header {
      flex-direction: column;
      height: auto;
      padding: 10px;
    }
    
    .nav {
      margin: 10px 0;
      width: 100%;
    }
    
    .footer-content {
      flex-direction: column;
    }
    
    .footer-section {
      margin-bottom: 20px;
    }
  }
  </style>