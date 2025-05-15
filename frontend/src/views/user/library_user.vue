<template>
    <div class="book-query-container">
      <!-- 固定顶部导航栏 -->
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
  
      <!-- 主要内容区域 -->
      <main class="main-content">
        <!-- 搜索区域 -->
        <section class="search-section">
          <div class="search-container">
            <h2 class="section-title">图书查询</h2>
            <el-form :inline="true" :model="searchForm" class="search-form">
              <el-form-item class="search-input">
                <el-input
                  v-model="searchForm.keyword"
                  placeholder="请输入书名、作者或ISBN"
                  clearable
                  size="large"
                  @keyup.enter="handleSearch"
                >
                  <template #prefix>
                    <el-icon><Search /></el-icon>
                  </template>
                </el-input>
              </el-form-item>
              
              <el-form-item class="category-select">
                <el-select
                  v-model="searchForm.category"
                  placeholder="全部分类"
                  clearable
                >
                  <el-option
                    v-for="item in categories"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value"
                  />
                </el-select>
              </el-form-item>
              
              <el-form-item class="search-buttons">
                <el-button type="primary" @click="handleSearch" size="large">
                  <el-icon><Search /></el-icon>
                  <span>搜索</span>
                </el-button>
                <el-button @click="resetSearch" size="large">重置</el-button>
              </el-form-item>
            </el-form>
            
            <div class="sort-options">
              <el-radio-group v-model="sortOption" @change="handleSortChange">
                <el-radio-button label="default">默认排序</el-radio-button>
                <el-radio-button label="popular">热门度</el-radio-button>
                <el-radio-button label="publishDate">出版时间</el-radio-button>
              </el-radio-group>
            </div>
          </div>
        </section>
  
        <!-- 图书列表 -->
        <section class="book-list-section">
          <div class="list-header">
            <h3 class="result-count">找到 {{ pagination.total }} 本图书</h3>
            <div class="view-options">
              <el-button-group>
                <el-button :type="viewMode === 'grid' ? 'primary' : ''" @click="viewMode = 'grid'">
                  <el-icon><Grid /></el-icon>
                </el-button>
                <el-button :type="viewMode === 'list' ? 'primary' : ''" @click="viewMode = 'list'">
                  <el-icon><List /></el-icon>
                </el-button>
              </el-button-group>
            </div>
          </div>
  
          <!-- 网格视图 -->
          <div v-if="viewMode === 'grid'" class="book-grid">
            <el-row :gutter="20">
              <el-col
                v-for="book in bookList"
                :key="book.id"
                :xs="12"
                :sm="8"
                :md="6"
                :lg="4"
                :xl="4"
              >
                <el-card class="book-card" shadow="hover" @click="showBookDetail(book)">
                  <div class="book-cover">
                    <img :src="book.cover || defaultCover" alt="图书封面">
                  </div>
                  <div class="book-info">
                    <h3 class="book-title">{{ book.title }}</h3>
                    <p class="book-author">{{ book.author }}</p>
                    <el-rate
                      v-model="book.rating"
                      disabled
                      show-score
                      text-color="#ff9900"
                      score-template="{value}分"
                    />
                  </div>
                </el-card>
              </el-col>
            </el-row>
          </div>
  
          <!-- 列表视图 -->
          <div v-else class="book-table">
            <el-table :data="bookList" style="width: 100%" @row-click="showBookDetail">
              <el-table-column prop="cover" label="封面" width="100">
                <template #default="{row}">
                  <img :src="row.cover || defaultCover" class="table-cover" alt="图书封面">
                </template>
              </el-table-column>
              <el-table-column prop="title" label="书名" width="200" />
              <el-table-column prop="author" label="作者" width="120" />
              <el-table-column prop="publisher" label="出版社" width="150" />
              <el-table-column prop="publishDate" label="出版日期" width="120" />
              <el-table-column prop="rating" label="评分" width="120">
                <template #default="{row}">
                  <el-rate v-model="row.rating" disabled />
                </template>
              </el-table-column>
              <el-table-column prop="stock" label="库存" width="80" />
              <el-table-column label="操作" width="120">
                <template #default="{row}">
                  <el-button type="primary" size="small" @click.stop="addToCart(row)">借阅</el-button>
                </template>
              </el-table-column>
            </el-table>
          </div>
        </section>
  
        <!-- 分页 -->
        <div class="pagination-container">
          <el-pagination
            v-model:current-page="pagination.currentPage"
            v-model:page-size="pagination.pageSize"
            :total="pagination.total"
            :page-sizes="[12, 24, 48, 96]"
            layout="total, sizes, prev, pager, next, jumper"
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
          />
        </div>
      </main>
  
      <!-- 图书详情对话框 -->
      <el-dialog
        v-model="detailDialogVisible"
        :title="currentBook.title"
        width="60%"
      >
        <div class="book-detail">
          <el-row :gutter="20">
            <el-col :span="8">
              <div class="detail-cover">
                <img :src="currentBook.cover || defaultCover" alt="图书封面">
              </div>
            </el-col>
            <el-col :span="16">
              <div class="detail-info">
                <h2>{{ currentBook.title }}</h2>
                <p><span>作者：</span>{{ currentBook.author }}</p>
                <p><span>出版社：</span>{{ currentBook.publisher }}</p>
                <p><span>出版日期：</span>{{ currentBook.publishDate }}</p>
                <p><span>ISBN:</span>{{ currentBook.isbn }}</p>
                <p><span>库存：</span>{{ currentBook.stock }}本</p>
                <el-rate
                  v-model="currentBook.rating"
                  disabled
                  show-score
                  text-color="#ff9900"
                  score-template="{value}分"
                />
                <div class="book-description">
                  <h3>内容简介</h3>
                  <p>{{ currentBook.description }}</p>
                </div>
              </div>
            </el-col>
          </el-row>
        </div>
        <template #footer>
          <el-button @click="detailDialogVisible = false">关闭</el-button>
          <el-button type="primary" @click="addToCart(currentBook)">加入借阅车</el-button>
        </template>
      </el-dialog>
    </div>
  </template>
  
  <script setup>
  import axios from 'axios'
  import { ref, reactive, onMounted } from 'vue'
  import { Search, Grid, List } from '@element-plus/icons-vue'
  import { useNavigation } from '@/utils/Select'
  
  // 默认封面图
  const defaultCover = 'https://via.placeholder.com/200x280?text=No+Cover'
  
  // 视图模式
  const viewMode = ref('grid')
  
  // 跳转
  const { handleSelect } = useNavigation()
  
  // 搜索表单
  const searchForm = reactive({
    keyword: '',
    category: ''
  })
  
  // 分类选项
  const categories = ref([
    { value: 'literature', label: '文学' },
    { value: 'science', label: '科学' },
    { value: 'technology', label: '技术' },
    { value: 'history', label: '历史' },
    { value: 'philosophy', label: '哲学' },
    { value: 'art', label: '艺术' },
    { value: 'economics', label: '经济' },
    { value: 'education', label: '教育' }
  ])
  
  // 排序选项
  const sortOption = ref('default')
  
  // 分页信息
  const pagination = reactive({
    currentPage: 1,
    pageSize: 12,
    total: 0
  })
  
  // 图书列表
  const bookList = ref([])
  
  // 当前查看的图书详情
  const currentBook = reactive({
    id: '',
    title: '',
    author: '',
    publisher: '',
    publishDate: '',
    isbn: '',
    price: 0,
    stock: 0,
    rating: 0,
    cover: '',
    description: ''
  })
  
  // 详情对话框显示状态
  const detailDialogVisible = ref(false)
  
  // 搜索图书
  const handleSearch = () => {
    pagination.currentPage = 1
    fetchBooks()
  }
  
  // 重置搜索
  const resetSearch = () => {
    searchForm.keyword = ''
    searchForm.category = ''
    sortOption.value = 'default'
    handleSearch()
  }
  
  // 排序变化
  const handleSortChange = () => {
    fetchBooks()
  }
  
  // 分页大小变化
  const handleSizeChange = (size) => {
    pagination.pageSize = size
    fetchBooks()
  }
  
  // 当前页变化
  const handleCurrentChange = (page) => {
    pagination.currentPage = page
    fetchBooks()
  }
  
  // 显示图书详情
  const showBookDetail = (book) => {
    Object.assign(currentBook, book)
    detailDialogVisible.value = true
  }
  
  // 加入借阅车
  const addToCart = (book) => {
    // 实际项目中调用API加入借阅车
    ElMessage.success(`《${book.title}》已加入借阅车`)
    detailDialogVisible.value = false
  }
const fetchBooks = async () => {
  try {
    const res = await axios.get('http://localhost:8989/api/books', {
      params: {
        ...searchForm, // 直接展开searchForm
        page: pagination.currentPage,
        pageSize: pagination.pageSize
      }
    })
    // 后端返回的数据结构应该是 { books: [...], total: 100 }
    bookList.value = res.data.books
    pagination.total = res.data.total
  } catch (err) {
    console.error('获取图书失败', err)
    ElMessage.error('获取图书失败，请检查网络或后端接口')
  }
}

  // 组件挂载时获取数据
  onMounted(() => {
    fetchBooks()
  })
  </script>
  
  <style scoped>
  /* 整体布局 */
  .book-query-container {
    display: flex;
    flex-direction: column;
    height: 100vh;
    overflow: hidden;
  }
  
  /* 固定顶部导航栏 */
  .header {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 20px;
    height: 60px;
    background-color: #fff;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    z-index: 1000;
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
  
  /* 主要内容区域 */
  .main-content {
    flex: 1;
    margin-top: 60px;
    padding: 20px;
    overflow-y: auto;
    background-color: #f5f7fa;
  }
  
  /* 搜索区域 */
  .search-section {
    background-color: #fff;
    padding: 20px;
    margin-bottom: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  }
  
  .search-container {
    max-width: 1200px;
    margin: 0 auto;
  }
  
  .section-title {
    margin-bottom: 20px;
    color: #303133;
    font-size: 20px;
    font-weight: 500;
  }
  
  .search-form {
    display: flex;
    flex-wrap: wrap;
    gap: 15px;
    align-items: center;
  }
  
  .search-input {
    flex: 1;
    min-width: 300px;
  }
  
  .category-select {
    min-width: 200px;
  }
  
  .search-buttons {
    margin-left: auto;
  }
  
  .sort-options {
    margin-top: 15px;
    text-align: center;
  }
  
  /* 图书列表区域 */
  .book-list-section {
    background-color: #fff;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    margin-bottom: 20px;
  }
  
  .list-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
  }
  
  .result-count {
    color: #606266;
    font-size: 16px;
  }
  
  /* 网格视图 */
  .book-grid {
    margin-top: 20px;
  }
  
  .book-card {
    margin-bottom: 20px;
    cursor: pointer;
    transition: all 0.3s;
    border-radius: 8px;
    overflow: hidden;
  }
  
  .book-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
  }
  
  .book-cover {
    text-align: center;
    margin-bottom: 10px;
    height: 200px;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #f5f7fa;
  }
  
  .book-cover img {
    max-height: 100%;
    max-width: 100%;
    object-fit: contain;
  }
  
  .book-info {
    padding: 10px;
  }
  
  .book-title {
    font-size: 16px;
    margin-bottom: 5px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  
  .book-author {
    color: #666;
    font-size: 14px;
    margin-bottom: 5px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  
  /* 列表视图 */
  .book-table {
    margin-top: 20px;
  }
  
  .table-cover {
    width: 60px;
    height: 80px;
    object-fit: cover;
  }
  
  /* 分页 */
  .pagination-container {
    position: sticky;
    bottom: 0;
    background-color: #fff;
    padding: 15px 0;
    border-radius: 8px;
    box-shadow: 0 -2px 8px rgba(0, 0, 0, 0.05);
    z-index: 100;
  }
  
  /* 图书详情 */
  .book-detail {
    padding: 10px;
  }
  
  .detail-cover {
    text-align: center;
    padding: 20px;
  }
  
  .detail-cover img {
    max-width: 100%;
    max-height: 300px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  }
  
  .detail-info h2 {
    margin-bottom: 15px;
    color: #303133;
  }
  
  .detail-info p {
    margin-bottom: 10px;
    color: #606266;
  }
  
  .detail-info p span {
    color: #303133;
    font-weight: bold;
  }
  
  .book-description {
    margin-top: 20px;
    padding-top: 15px;
    border-top: 1px solid #eee;
  }
  
  .book-description h3 {
    margin-bottom: 10px;
    color: #303133;
  }
  
  .book-description p {
    line-height: 1.6;
    color: #606266;
  }
  
  /* 响应式设计 */
  @media (max-width: 768px) {
    .search-form {
      flex-direction: column;
      align-items: stretch;
    }
    
    .search-input,
    .category-select {
      width: 100%;
      min-width: auto;
    }
    
    .search-buttons {
      margin-left: 0;
      width: 100%;
      display: flex;
      justify-content: space-between;
    }
    
    .list-header {
      flex-direction: column;
      align-items: flex-start;
      gap: 10px;
    }
    
    .view-options {
      align-self: flex-end;
    }
  }
  </style>