<template>
    <div class="about-container">
      <!-- 顶部导航栏 - 与首页相同 -->
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
                <el-dropdown-item @click="goToProfile">个人中心</el-dropdown-item>
                <el-dropdown-item>系统设置</el-dropdown-item>
                <el-dropdown-item divided @click="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </header>
  
      <!-- 主要内容区 - 关于我们专属内容 -->
      <main class="main-content">
        <section class="about-section">
          <h1 class="about-title">关于深圳技术大学</h1>
          
          <div class="about-content">
            <div class="about-image">
              <img src="@/assets/photo/library_photo.jpg" alt="校园全景">
            </div>
            
            <div class="about-text">
              <h2>学校简介</h2>
              <p>深圳技术大学是深圳市的一所公立应用技术型大学，致力于培养具有国际视野、工匠精神和创新创业能力的高水平工程师、设计师等应用型人才。</p>
              
              <h2>办学特色</h2>
              <ul>
                <li>国际化办学：与德国、瑞士等国家多所应用技术大学合作</li>
                <li>产教融合：与企业深度合作，注重实践能力培养</li>
                <li>创新驱动：鼓励学生参与创新创业项目</li>
                <li>应用导向：课程设置紧密结合产业需求</li>
              </ul>
              
              <h2>校园设施</h2>
              <p>学校拥有现代化的教学设施、实验室和实训中心，图书馆藏书丰富，体育设施完善，为学生提供良好的学习和生活环境。</p>
            </div>
          </div>
          
          <div class="contact-info">
            <h2>联系我们</h2>
            <div class="contact-grid">
              <div class="contact-item">
                <el-icon><Location /></el-icon>
                <span>地址:广东省深圳市坪山区兰田路3002号</span>
              </div>
              <div class="contact-item">
                <el-icon><Phone /></el-icon>
                <span>电话:0755-23256000</span>
              </div>
              <div class="contact-item">
                <el-icon><Message /></el-icon>
                <span>邮箱:info@sztu.edu.cn</span>
              </div>
              <div class="contact-item">
                <el-icon><Link /></el-icon>
                <span>官网：<el-link href="https://www.sztu.edu.cn" target="_blank">www.sztu.edu.cn</el-link></span>
              </div>
            </div>
          </div>
        </section>
      </main>
  
      <!-- 页脚 - 与首页相同 -->
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
  import { ref, computed } from 'vue'
  import { useRouter, useRoute } from 'vue-router'
  import {
    Location,
    Phone,
    Message,
    Link
  } from '@element-plus/icons-vue'
  import logoUrl from '@/assets/photo/sztu-logo.jpg'
  import userAvatar from '@/assets/photo/user.png'
  
  
  const handleSelect = (index) => {
    router.push(index)
  }
  const router = useRouter()
  const route = useRoute()
  
  // 导航菜单激活状态
  const activeIndex = computed(() => {
    return route.path
  })
  // 退出登录
  const logout = () => {
    router.push('/login')
  }
  const goToProfile = () => {
    router.push('/ownpeople')
  }
  
  
  </script>
  
  <style scoped>
  .about-container {
    width: 100vw;
    height: 100vh;
    overflow: auto;
    display: flex;
    flex-direction: column;
    background-color: #fff;
  }
  
  /* 顶部导航栏样式 - 与首页相同 */
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
    padding: 40px 20px;
    max-width: 1200px;
    margin: 0 auto;
    width: 100%;
  }
  
  .about-section {
    max-width: 1000px;
    margin: 0 auto;
  }
  
  .about-title {
    text-align: center;
    font-size: 28px;
    color: #303133;
    margin-bottom: 40px;
    padding-bottom: 15px;
    border-bottom: 2px solid #409eff;
  }
  
  .about-content {
    display: flex;
    gap: 40px;
    margin-bottom: 40px;
  }
  
  .about-image {
    flex: 1;
  }
  
  .about-image img {
    width: 100%;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  }
  
  .about-text {
    flex: 1;
  }
  
  .about-text h2 {
    color: #409eff;
    margin: 20px 0 15px;
    font-size: 20px;
  }
  
  .about-text p {
    line-height: 1.8;
    color: #606266;
    margin-bottom: 15px;
  }
  
  .about-text ul {
    padding-left: 20px;
    color: #606266;
    line-height: 1.8;
  }
  
  .contact-info {
    background-color: #f5f7fa;
    padding: 30px;
    border-radius: 8px;
  }
  
  .contact-info h2 {
    color: #409eff;
    margin-bottom: 20px;
    text-align: center;
    font-size: 22px;
  }
  
  .contact-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
  }
  
  .contact-item {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 16px;
    color: #606266;
  }
  
  /* 页脚样式 - 与首页相同 */
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
    .about-content {
      flex-direction: column;
    }
    
    .contact-grid {
      grid-template-columns: 1fr;
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
    
    .main-content {
      padding: 20px 15px;
    }
  }
  </style>