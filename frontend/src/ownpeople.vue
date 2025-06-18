<template>
    <div class="profile-container">
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
              <span class="username">管理员</span>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="goToadminProfile">个人中心</el-dropdown-item>
                <el-dropdown-item>系统设置</el-dropdown-item>
                <el-dropdown-item divided @click="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </header>
  
      <!-- 个人中心内容 -->
      <main class="profile-main">
        <el-card class="profile-card">
          <div class="profile-header">
            <el-avatar :size="80" :src="userAvatarref" />
            <div class="profile-info">
              <h2>{{ userInfo.username }}</h2>
              <p>角色：{{ userInfo.role === 'admin' ? '管理员' : '普通用户' }}</p>
              <p>注册时间：{{ userInfo.created_at }}</p>
            </div>
          </div>
          <el-divider />
          <el-form label-width="100px" class="profile-form">
            <el-form-item label="用户名">
              <el-input v-model="userInfo.username" disabled />
            </el-form-item>
            <el-form-item label="邮箱">
              <el-input v-model="userInfo.email" placeholder="未设置" />
            </el-form-item>
            <el-form-item label="修改密码">
              <el-input v-model="password" type="password" placeholder="新密码" show-password />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="updatePassword">修改密码</el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </main>
    </div>
  </template>
  
  <script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import axios from 'axios'
import userAvatar from '@/assets/photo/user.png'
import { useNavigation } from '@/utils/Select'

const router = useRouter()
const userAvatarref = ref(userAvatar)
const activeIndex = ref('1')
const { handleSelect } = useNavigation()

// 用户信息
const userInfo = reactive({
  username: '',
  role: '',
  created_at: '',
  email: ''
})

const password = ref('')

// 页面加载时获取用户信息
onMounted(async () => {
  // 假设用户名保存在 localStorage
  const user = JSON.parse(localStorage.getItem('userInfo') || '{}')
  if (!user.username) {
    ElMessage.error('未登录')
    router.push('/login')
    return
  }
  try {
    const res = await axios.get('http://localhost:8989/api/users/info', {
      params: { username: user.username }
    })
    Object.assign(userInfo, res.data.user)
  } catch (e) {
    ElMessage.error('获取用户信息失败')
  }
})

const updatePassword = async () => {
  if (!password.value) {
    ElMessage.warning('请输入新密码')
    return
  }
  try {
    await axios.post('http://localhost:8989/api/users/change-password', {
      username: userInfo.username,
      newPassword: password.value
    })
    ElMessage.success('密码修改成功')
    password.value = ''
  } catch (e) {
    ElMessage.error('密码修改失败')
  }
}

const logout = () => {
  router.push('/login')
}
</script>
  
  <style scoped>
  .profile-container {
    width:100vw;
    min-height: 100vh;
    background: #f5f7fa;
    display: flex;
    flex-direction: column;
  }
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
  .profile-main {
    flex: 1;
    display: flex;
    justify-content: center;
    align-items: flex-start;
    padding: 40px 0;
  }
  .profile-card {
    width: 500px;
    padding: 30px;
  }
  .profile-header {
    display: flex;
    align-items: center;
    margin-bottom: 20px;
  }
  .profile-info {
    margin-left: 24px;
  }
  .profile-info h2 {
    margin: 0 0 8px 0;
  }
  .profile-form {
    margin-top: 20px;
  }
  </style>