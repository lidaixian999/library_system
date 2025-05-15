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
            <el-menu-item index="1">首页</el-menu-item>
            <el-menu-item index="2">图书馆</el-menu-item>
            <el-menu-item index="3">教学资源</el-menu-item>
            <el-menu-item index="4">校园生活</el-menu-item>
            <el-menu-item index="5">关于我们</el-menu-item>
          </el-menu>
        </nav>
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
      </main>
  
      <!-- 页脚 -->
      <footer class="footer">
        <div class="copyright">
          <p>© 2025 深圳技术大学 版权所有</p>
        </div>
      </footer>
    </div>
  </template>
  
  <script setup>
  import { ref, computed } from 'vue'
  import { useRouter, useRoute } from 'vue-router'
  import {
    Reading,
    Notebook,
    School,
    Calendar,
    Document,
    Bell
  } from '@element-plus/icons-vue'
  import banner1 from '@/assets/photo/banner1.jpg'
  import banner2 from '@/assets/photo/banner2.jpg'
  import banner3 from '@/assets/photo/banner3.jpg'
  import banner4 from '@/assets/photo/banner4.jpg'
  
  const router = useRouter()
  const route = useRoute()
  
  // 导航菜单
  const activeIndex = computed(() => {
    switch (route.path) {
      case '/home_user': return '1'
      case '/library_user': return '2'
      case '/resources_user': return '3'
      case '/campus_life': return '4'
      case '/about': return '5'
      default: return '1'
    }
  })
  
  const handleSelect = (key) => {
    switch (key) {
      case '1': router.push('/home_user'); break
      case '2': router.push('/library_user'); break
      case '3': router.push('/resources_user'); break
      case '4': router.push('/campus_life'); break
      case '5': router.push('/about'); break
      default: break
    }
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
  
  // 快速入口
  const quickAccess = ref([
    { title: '图书查询', desc: '查询馆藏图书信息', icon: Reading, path: '/library_user' },
    { title: '我的借阅', desc: '您目前借阅的书籍', icon: Notebook, path: '/borrow_user' },
    { title: '学习资源', desc: '访问学习所需资料', icon: School, path: '/resources_user' },
    { title: '校历查询', desc: '查看学校校历安排', icon: Calendar, path: '/calendar_user' },
    { title: '文件下载', desc: '下载各类表格文件', icon: Document, path: '/download_user' },
    { title: '系统公告', desc: '查看系统公告信息', icon: Bell, path: '/notice_user' }
  ])
  
  const goTo = (path) => {
    router.push(path)
  }
  </script>
  
  <style scoped>
  .home-container {
    width: 100vw;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
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
    height: 100%;
    color: #ffffff;
    font-size: 24px;
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
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
  
  /* 页脚样式 */
  .footer {
    background-color: #303133;
    color: #fff;
    padding: 20px 0;
  }
  
  .copyright {
    text-align: center;
    font-size: 14px;
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
  }
  </style>