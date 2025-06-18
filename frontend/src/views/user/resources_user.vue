<template>
    <div class="learning-resources-container">
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
              <el-dropdown-item @click="goToProfile">个人中心</el-dropdown-item>
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
          <h1>学习资源中心</h1>
          <div class="search-box">
            <el-input
              v-model="searchKeyword"
              placeholder="搜索课程、资料..."
              clearable
              @keyup.enter="handleSearch"
            >
              <template #append>
                <el-button @click="handleSearch">
                  <el-icon><Search /></el-icon>
                </el-button>
              </template>
            </el-input>
          </div>
        </div>
  
        <!-- 分类筛选 -->
        <div class="filter-section">
          <el-tabs v-model="activeCategory" @tab-change="handleCategoryChange">
            <el-tab-pane v-for="category in categories" :key="category.value" :label="category.label" :name="category.value" />
          </el-tabs>
          
          <div class="sort-options">
            <el-select v-model="sortOption" placeholder="排序方式" @change="handleSortChange">
              <el-option
                v-for="item in sortOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              />
            </el-select>
          </div>
        </div>
  
        <!-- 资源列表 -->
        <div class="resource-list">
          <el-row :gutter="20">
            <el-col v-for="resource in filteredResources" :key="resource.id" :xs="24" :sm="12" :md="8" :lg="6">
              <el-card class="resource-card" shadow="hover">
                <div class="resource-cover">
                  <img :src="resource.cover || defaultCover" :alt="resource.title">
                  <div class="resource-type">{{ resource.type }}</div>
                </div>
                <div class="resource-info">
                  <h3 class="resource-title">{{ resource.title }}</h3>
                  <div class="resource-meta">
                    <span><el-icon><User /></el-icon> {{ resource.author }}</span>
                    <span><el-icon><Clock /></el-icon> {{ resource.duration }}</span>
                  </div>
                  <div class="resource-desc">{{ resource.description }}</div>
                  <div class="resource-actions">
                    <el-button type="primary" size="small" @click="viewResource(resource)">查看</el-button>
                    <el-button size="small" @click="downloadResource(resource)">下载</el-button>
                  </div>
                </div>
              </el-card>
            </el-col>
          </el-row>
        </div>
  
        <!-- 分页 -->
        <div class="pagination">
          <el-pagination
            v-model:current-page="currentPage"
            v-model:page-size="pageSize"
            :total="totalResources"
            :page-sizes="[12, 24, 48]"
            layout="total, sizes, prev, pager, next, jumper"
            @size-change="handleSizeChange"
            @current-change="handlePageChange"
          />
        </div>
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
          <p>© 2025 王禹涵 版权所有</p>
        </div>
      </footer>
    </div>
  </template>
  
  <script setup>
  import { ref, computed, onMounted } from 'vue'
  import { useRouter, useRoute } from 'vue-router'
  import { Search, User, Clock } from '@element-plus/icons-vue'

  const router = useRouter()
  const route = useRoute()
  // 用户信息
  const userAvatar = ref('@/assets/photo/user.png')
  
  // 导航菜单
  const activeIndex = computed(() => {
  return route.path // 直接返回当前路由路径
})
  const handleSelect = (index) => {
    activeIndex.value = index
    router.push(index)
  }
  
  // 搜索功能
  const searchKeyword = ref('')
  const handleSearch = () => {
    console.log('搜索:', searchKeyword.value)
  }
  
  // 分类筛选
  const categories = ref([
    { value: 'all', label: '全部' },
    { value: 'video', label: '视频课程' },
    { value: 'document', label: '文档资料' },
    { value: 'interactive', label: '互动学习' },
    { value: 'exam', label: '考试资料' }
  ])
  const activeCategory = ref('all')
  const handleCategoryChange = (tab) => {
    console.log('切换分类:', tab)
  }
  
  // 排序选项
  const sortOptions = ref([
    { value: 'default', label: '默认排序' },
    { value: 'popular', label: '热门度' },
    { value: 'newest', label: '最新上传' },
    { value: 'rating', label: '评分最高' }
  ])
  const sortOption = ref('default')
  const handleSortChange = (value) => {
    console.log('排序方式:', value)
  }
  
  // 分页
  const currentPage = ref(1)
  const pageSize = ref(12)
  const totalResources = ref(100)
  const handleSizeChange = (size) => {
    pageSize.value = size
  }
  const handlePageChange = (page) => {
    currentPage.value = page
  }
  
  // 资源数据
  const defaultCover = ref('https://via.placeholder.com/300x200?text=No+Cover')
  const resources = ref([
    {
      id: 1,
      title: 'Vue.js 3.0 入门教程',
      author: '张老师',
      type: '视频课程',
      cover: 'https://picsum.photos/300/200?random=1',
      duration: '12小时',
      description: '从零开始学习Vue.js 3.0框架，掌握核心概念和实战技巧',
      rating: 4.8,
      viewCount: 1250,
      uploadTime: '2025-04-10'
    },
    {
      id: 2,
      title: 'Python数据分析实战',
      author: '李教授',
      type: '文档资料',
      cover: 'https://picsum.photos/300/200?random=2',
      duration: 'PDF 85页',
      description: '使用Python进行数据分析的完整指南，包含NumPy、Pandas等库的使用',
      rating: 4.5,
      viewCount: 980,
      uploadTime: '2025-03-25'
    },
    {
      id: 3,
      title: 'JavaScript高级编程',
      author: '王老师',
      type: '互动学习',
      cover: 'https://picsum.photos/300/200?random=3',
      duration: '8章',
      description: '深入理解JavaScript核心概念，包含大量交互式练习',
      rating: 4.7,
      viewCount: 1560,
      uploadTime: '2025-04-05'
    },
    {
      id: 4,
      title: '数据库系统原理',
      author: '赵教授',
      type: '视频课程',
      cover: 'https://picsum.photos/300/200?random=4',
      duration: '15小时',
      description: '全面讲解数据库系统原理，包含SQL优化和事务处理',
      rating: 4.6,
      viewCount: 890,
      uploadTime: '2025-03-15'
    },
    {
      id: 5,
      title: '计算机网络基础',
      author: '刘老师',
      type: '文档资料',
      cover: 'https://picsum.photos/300/200?random=5',
      duration: 'PDF 120页',
      description: '计算机网络基础知识，包含TCP/IP协议栈详解',
      rating: 4.4,
      viewCount: 760,
      uploadTime: '2025-04-01'
    },
    {
      id: 6,
      title: '数据结构与算法',
      author: '陈教授',
      type: '互动学习',
      cover: 'https://picsum.photos/300/200?random=6',
      duration: '10章',
      description: '常见数据结构和算法的可视化学习，包含交互式演示',
      rating: 4.9,
      viewCount: 2100,
      uploadTime: '2025-03-20'
    }
  ])
  
  // 过滤后的资源
  const filteredResources = computed(() => {
    let result = [...resources.value]
    
    // 搜索过滤
    if (searchKeyword.value) {
      const keyword = searchKeyword.value.toLowerCase()
      result = result.filter(resource => 
        resource.title.toLowerCase().includes(keyword) || 
        resource.author.toLowerCase().includes(keyword) ||
        resource.description.toLowerCase().includes(keyword)
      )
    }
    
    // 分类过滤
    if (activeCategory.value !== 'all') {
      result = result.filter(resource => resource.type.includes(activeCategory.value))
    }
    
    // 排序
    switch (sortOption.value) {
      case 'popular':
        result.sort((a, b) => b.viewCount - a.viewCount)
        break
      case 'newest':
        result.sort((a, b) => new Date(b.uploadTime) - new Date(a.uploadTime))
        break
      case 'rating':
        result.sort((a, b) => b.rating - a.rating)
        break
      default:
        // 默认排序不做处理
        break
    }
    
    return result
  })
  
  // 操作方法
  const viewResource = (resource) => {
    console.log('查看资源:', resource)
    // 实际应用中这里应该跳转到资源详情页
  }
  
  const downloadResource = (resource) => {
    console.log('下载资源:', resource)
    // 实际应用中这里应该调用下载API
  }
  
  const logout = () => {
    router.push('/login')
  }
  // 用户头像
const userAvatarref = ref(userAvatar)
// 个人中心
const goToProfile = () => {
  router.push('/ownpeople')
}

  </script>

  <style scoped>
  .learning-resources-container {
    width: 100vw;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    background-color: #f5f7fa;
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
  
  .page-header {
    display: flex;
    flex-direction: column;
    margin-bottom: 20px;
  }
  
  .page-header h1 {
    font-size: 24px;
    margin-bottom: 15px;
    color: #303133;
  }
  
  .search-box {
    width: 100%;
    max-width: 500px;
    margin: 0 auto;
  }
  
  .filter-section {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    background-color: #fff;
    padding: 15px;
    border-radius: 4px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  }
  
  .sort-options {
    width: 150px;
  }
  
  /* 资源列表样式 */
  .resource-list {
    margin-bottom: 20px;
  }
  
  .resource-card {
    margin-bottom: 20px;
    transition: all 0.3s;
    height: 100%;
  }
  
  .resource-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
  }
  
  .resource-cover {
    position: relative;
    height: 0;
    padding-bottom: 60%;
    overflow: hidden;
  }
  
  .resource-cover img {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
  
  .resource-type {
    position: absolute;
    top: 10px;
    right: 10px;
    background-color: rgba(0, 0, 0, 0.7);
    color: #fff;
    padding: 2px 8px;
    border-radius: 4px;
    font-size: 12px;
  }
  
  .resource-info {
    padding: 15px;
  }
  
  .resource-title {
    font-size: 16px;
    margin-bottom: 10px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  
  .resource-meta {
    display: flex;
    justify-content: space-between;
    font-size: 12px;
    color: #909399;
    margin-bottom: 10px;
  }
  
  .resource-meta span {
    display: flex;
    align-items: center;
  }
  
  .resource-meta .el-icon {
    margin-right: 5px;
  }
  
  .resource-desc {
    font-size: 14px;
    color: #606266;
    margin-bottom: 15px;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  
  .resource-actions {
    display: flex;
    justify-content: space-between;
  }
  
  /* 分页样式 */
  .pagination {
    display: flex;
    justify-content: center;
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
    
    .filter-section {
      flex-direction: column;
      align-items: flex-start;
    }
    
    .sort-options {
      width: 100%;
      margin-top: 10px;
    }
    
    .footer-content {
      flex-direction: column;
    }
    
    .footer-section {
      margin-bottom: 20px;
    }
  }
  </style>