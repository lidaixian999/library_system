
<template>
    <div class="home-container">
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
            <el-menu-item index="/home_controller">首页</el-menu-item>
            <el-menu-item index="/library_controller">图书馆</el-menu-item>
            <el-menu-item index="/resources_admin">教学资源</el-menu-item>
            <el-menu-item index="/campus_life_admin">校园生活</el-menu-item>
            <el-menu-item index="/about_me_admin">关于我们</el-menu-item>
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
                <el-dropdown-item @click="goToadminPeople">个人中心</el-dropdown-item>
                <el-dropdown-item>系统设置</el-dropdown-item>
                <el-dropdown-item divided @click="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </header>
  
      <!-- 主要内容区 -->
      <main class="main-content">
        <!-- 轮播图 -->
        <section class="banner">
          <el-carousel height="400px">
            <el-carousel-item v-for="item in 4" :key="item.id">
              <div class="carousel-item" :style="{ backgroundImage: `url(${getBannerImage(item-1)})` }">
                <h3>深技大校园风光 {{ item }}</h3>
              </div>
            </el-carousel-item>
          </el-carousel>
        </section>
  
        <!-- 快速入口 -->
        <section class="quick-access">
          <h2 class="section-title">快速入口</h2>
          <div class="access-grid">
            <div class="access-item" v-for="item in quickAccess" :key="item.title">
              <el-card shadow="hover" @click="goTo(item.path)">
                <div class="access-icon">
                  <el-icon :size="40"><component :is="item.icon" /></el-icon>
                </div>
                <h3>{{ item.title }}</h3>
                <p>{{ item.desc }}</p>
              </el-card>
            </div>
          </div>
        </section>
  
        <!-- 新闻公告 -->
        <section class="news-section">
          <h2 class="section-title">新闻公告</h2>
          <el-tabs v-model="activeNewsTab" class="news-tabs">
            <el-tab-pane label="学校新闻" name="news">
              <el-table :data="newsList" style="width: 100%">
                <el-table-column prop="title" label="标题" width="300" />
                <el-table-column prop="date" label="日期" width="120" />
                <el-table-column prop="department" label="发布部门" />
              </el-table>
            </el-tab-pane>
            <el-tab-pane label="通知公告" name="notice">
              <el-table :data="noticeList" style="width: 100%">
                <el-table-column prop="title" label="标题" width="300" />
                <el-table-column prop="date" label="日期" width="120" />
                <el-table-column prop="department" label="发布部门" />
              </el-table>
            </el-tab-pane>
          </el-tabs>
        </section>
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
  import { ref,computed } from 'vue'
  import { useRouter ,useRoute} from 'vue-router'
  import {
    User,
    Lock,
    Reading,
    Notebook,
    School,
    Calendar,
    Document,
    Bell,
    Collection,
    Setting,
    Histogram,
    DataLine
  } from '@element-plus/icons-vue'
  import logoUrl from '@/assets/photo/sztu-logo.jpg'
  import userAvatar from '@/assets/photo/user.png'
  import banner1 from '@/assets/photo/banner1.jpg'
  import banner2 from '@/assets/photo/banner2.jpg'
  import banner3 from '@/assets/photo/banner3.jpg'
  import banner4 from '@/assets/photo/banner4.jpg'
  const router = useRouter()
  const route = useRoute()
  // 暴露图片给模板使用
  const logoUrlref = ref(logoUrl)
  const userAvatarref = ref(userAvatar)
  // 导航菜单
  const activeIndex = computed(() => {
  return route.path
})
  const handleSelect = (index) => {
    router.push(index)
  }
  const getBannerImage = (index) => {
  return banners.value[index].image
}
  // 轮播图数据
  const banners = ref([
  { id: 1, title: '校园风光1', image: banner1 },
  { id: 2, title: '校园风光2', image: banner2 },
  { id: 3, title: '校园风光3', image: banner3 },
  { id: 4, title: '校园风光4', image: banner4 }
])
const goToadminPeople = () => {
    router.push('/ownpeople')
  }
  // 快速入口
  const quickAccess = ref([
    { title: '图书查询与管理', desc: '查询馆藏图书信息，管理图书借阅', icon: Reading, path: '/library_controller' },
    { title: '图书借阅管理', desc: '管理借阅馆藏可借图书', icon: Notebook, path: '/borrow_admin' },
    { title: '学习资源', desc: '访问学习所需资料', icon: School, path: '/resources_admin' },
    { title: '校历查询', desc: '查看学校校历安排', icon: Calendar, path: '/calendar' },
    { title: '文件下载', desc: '下载各类表格文件', icon: Document, path: '/download' },
    { title: '系统公告', desc: '查看系统公告信息', icon: Bell, path: '/notice' }
  ])
  
  // 新闻公告
  const activeNewsTab = ref('news')
  const newsList = ref([
    { title: '深圳技术大学2023年开学典礼隆重举行', date: '2023-09-01', department: '校长办公室' },
    { title: '我校与德国高校签署合作协议', date: '2023-08-15', department: '国际交流处' },
    { title: '2023年度科研成果展示会圆满结束', date: '2023-07-20', department: '科研处' },
    { title: '校园开放日活动安排公告', date: '2023-06-10', department: '宣传部' }
  ])
  const noticeList = ref([
    { title: '关于2023-2024学年第一学期选课通知', date: '2023-08-20', department: '教务处' },
    { title: '图书馆暑期开放时间调整通知', date: '2023-07-05', department: '图书馆' },
    { title: '校园网系统升级维护公告', date: '2023-06-28', department: '信息中心' }
  ])
  
  // 跳转方法
  const goTo = (path) => {
    router.push(path)
  }
  
  // 退出登录
  const logout = () => {
    router.push('/login')
  }
  </script>
  
  <style scoped>
  .home-container {
  width: 100vw; /* 100% 视窗宽度 */
  height: 100vh; /* 100% 视窗高度 */
  overflow: auto; /* 内容超出时滚动 */
  display: flex; /* 弹性布局 */
  flex-direction: column; /* 垂直排列 */
  background-color:#fff;
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
    flex: 0 0 auto; /* 固定高度 */
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
  
  /* 轮播图样式 */
  .banner {
    margin-bottom: 30px;
    border-radius: 8px;
    overflow: hidden;
  }
  
  .carousel-item {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;  /* 确保高度有效 */
  color: #ffffff;
  font-size: 24px;
  background-size: cover;      /* 图片填充整个区域 */
  background-position: center; /* 图片居中 */
  background-repeat: no-repeat; /* 不重复 */
}
  
  /* 快速入口样式 */
  .quick-access {
    margin-bottom: 30px;
  }
  
  .section-title {
    font-size: 20px;
    color: #303133;
    margin-bottom: 20px;
    padding-bottom: 10px;
    border-bottom: 1px solid #ebeef5;
  }
  
  .access-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
  }
  
  .access-item {
    cursor: pointer;
  }
  
  .access-item h3 {
    margin: 10px 0;
    font-size: 16px;
  }
  
  .access-item p {
    color: #909399;
    font-size: 14px;
  }
  
  .access-icon {
    margin-bottom: 10px;
    color: #409eff;
  }
  
  /* 新闻公告样式 */
  .news-section {
    margin-bottom: 30px;
  }
  
  .news-tabs {
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
  @media (max-width: 992px) {
    .access-grid {
      grid-template-columns: repeat(2, 1fr);
    }
  }
  
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
    
    .access-grid {
      grid-template-columns: 1fr;
    }
    
    .footer-content {
      flex-direction: column;
    }
    
    .footer-section {
      margin-bottom: 20px;
    }
  }
  </style>