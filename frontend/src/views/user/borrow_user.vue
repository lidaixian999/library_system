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
            <el-menu-item index="/home_user">首页</el-menu-item>
            <el-menu-item index="/library_user">图书馆</el-menu-item>
            <el-menu-item index="/resources_user">教学资源</el-menu-item>
            <el-menu-item index="/campus_life">校园生活</el-menu-item>
            <el-menu-item index="/about_me">关于我们</el-menu-item>
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
          <h1 class="my-borrow-title">我的借阅</h1>
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
                  <el-tag :type="scope.row.status === 'borrowed' ? 'success' : 'danger'">
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
    <!-- 添加借阅时间选择对话框 -->
  <el-dialog
    v-model="borrowDialogVisible"
    title="选择借阅时间"
    width="30%"
  >
    <el-form :model="borrowForm" label-width="100px">
      <el-form-item label="借阅时间">
        <el-select v-model="borrowForm.duration" placeholder="请选择借阅时间">
          <el-option :value="30" label="1个月" />
          <el-option :value="90" label="3个月" />
          <el-option :value="180" label="6个月" />
          <el-option :value="365" label="1年" />
        </el-select>
      </el-form-item>
    </el-form>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="borrowDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmBorrow">确认借阅</el-button>
      </span>
    </template>
  </el-dialog>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue'
  import { useRouter } from 'vue-router'
  import { ElMessage } from 'element-plus'
  import axios from 'axios'
  import userAvatar from '@/assets/photo/user.png'
  
  const router = useRouter()
  const handleSelect = (index) => {
    router.push(index)
  }
  // 退出登录
  const logout = () => {
    router.push('/login')
  }
  // 导航菜单
  const activeIndex = ref('')
  const userAvatarref = ref(userAvatar)
  
  // 借阅数据
  const activeTab = ref('current')
  const currentBorrows = ref([])
  const borrowHistory = ref([])
  const goBack = () => {
    router.push('/home_user')
  }
  // 获取借阅数据
  const fetchBorrowData = async () => {
    try {
      const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
      const res = await axios.get('http://localhost:8989/api/borrow/list', {
        params: { username: userInfo.username }
      })
      currentBorrows.value = res.data.current
      borrowHistory.value = res.data.history
    } catch (error) {
      console.error('获取借阅记录失败:', error)
      ElMessage.error('获取借阅记录失败')
    }
  }
  
  // 续借方法
  const handleRenew = async (row) => {
    try {
      await axios.post('http://localhost:8989/api/borrow/renew', {
        recordId: row.recordId,
        duration: 30 // 添加默认续借天数
      })
      ElMessage.success('续借成功')
      fetchBorrowData() // 刷新数据
    } catch (error) {
      ElMessage.error(error.response?.data?.error || '续借失败')
    }
  }
  
  // 归还方法
  const handleReturn = async (row) => {
    try {
      await axios.post('http://localhost:8989/api/borrow/return', {
        recordId: row.recordId
      })
      ElMessage.success('归还成功')
      fetchBorrowData() // 刷新数据
    } catch (error) {
      ElMessage.error('归还失败')
    }
  }
  
  // 组件挂载时获取数据
  onMounted(() => {
    fetchBorrowData()
  })

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
  .my-borrow-title {
  color: #100404d5; /* 你想要的颜色，可以换成其他色值 */
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
    color: #150505d5;
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