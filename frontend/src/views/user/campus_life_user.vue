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

    <!-- 主要内容区域 -->
    <main class="main-content">
      <!-- 校园新闻公告 -->
      <section class="news-section">
        <div class="section-header">
          <h2>校园新闻</h2>
          <el-button type="primary" text>更多新闻</el-button>
        </div>
        <el-row :gutter="20">
          <el-col :xs="24" :sm="12" :md="8" v-for="news in newsList" :key="news.id">
            <el-card class="news-card" :body-style="{ padding: '0px' }" shadow="hover">
              <img :src="news.image" class="news-image">
              <div class="news-info">
                <h3>{{ news.title }}</h3>
                <p>{{ news.brief }}</p>
                <div class="bottom">
                  <time>{{ news.date }}</time>
                  <el-button type="primary" text @click="showNewsDetail(news)">查看详情</el-button>
                </div>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </section>

      <!-- 校园活动 -->
      <section class="activities-section">
        <div class="section-header">
          <h2>校园活动</h2>
          <el-button type="primary" text>更多活动</el-button>
        </div>
        <el-timeline>
          <el-timeline-item
            v-for="activity in activities"
            :key="activity.id"
            :timestamp="activity.time"
            :type="activity.type"
            placement="top"
          >
            <el-card shadow="hover">
              <h4>{{ activity.title }}</h4>
              <p>{{ activity.content }}</p>
              <p class="activity-location">
                <el-icon><Location /></el-icon>
                <span>地点：{{ activity.location }}</span>
              </p>
              <div class="activity-footer">
                <el-tag size="small" :type="activity.type">{{ activity.status }}</el-tag>
                <el-button size="small" type="primary" plain>立即报名</el-button>
              </div>
            </el-card>
          </el-timeline-item>
        </el-timeline>
      </section>

      <!-- 食堂信息 -->
      <section class="canteen-section">
        <div class="section-header">
          <h2>食堂信息</h2>
          <el-button type="primary" text>查看全部</el-button>
        </div>
        <el-table :data="canteenInfo" style="width: 100%" stripe>
          <el-table-column prop="name" label="食堂名称" width="180" />
          <el-table-column prop="floor" label="楼层" width="100" />
          <el-table-column prop="businessHours" label="营业时间" width="180" />
          <el-table-column prop="specialty" label="特色菜品" />
          <el-table-column label="操作" width="120">
            <template #default>
              <el-button link type="primary" size="small">查看详情</el-button>
            </template>
          </el-table-column>
        </el-table>
      </section>
    </main>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { Location } from '@element-plus/icons-vue'
import userAvatar from '@/assets/photo/user.png'

const router = useRouter()
const route = useRoute()
const userAvatarref = ref(userAvatar)

// 导航相关
const activeIndex = computed(() => route.path)
const handleSelect = (index) => router.push(index)
const goToProfile = () => router.push('/ownpeople')
const logout = () => router.push('/login')

// 新闻数据
const newsList = ref([
  {
    id: 1,
    title: '深技大举办2025届毕业典礼',
    brief: '深圳技术大学隆重举行2025届毕业典礼，校长发表重要讲话，勉励毕业生勇担时代使命...',
    image: '@/assets/photo/news1.jpg',
    date: '2025-05-16'
  },
  {
    id: 2,
    title: '校园科技创新大赛圆满落幕',
    brief: '第十届校园科技创新大赛决赛圆满结束，多个优秀项目获得投资方青睐...',
    image: '@/assets/photo/news2.jpg',
    date: '2025-04-28'
  },
  {
    id: 3,
    title: '国际学术交流周盛大开幕',
    brief: '我校与多所国际知名高校联合举办的国际学术交流周活动正式拉开帷幕...',
    image: '@/assets/photo/news3.jpg',
    date: '2025-03-15'
  }
])

// 活动数据
const activities = ref([
  {
    id: 1,
    title: '校园歌手大赛',
    content: '2025年校园歌手大赛报名开始啦！展示你的音乐才华，赢取丰厚奖品！',
    time: '2025-06-01 19:00',
    location: '学生活动中心',
    type: 'primary',
    status: '报名中'
  },
  {
    id: 2,
    title: '春季运动会',
    content: '一年一度的春季运动会即将举行，各学院代表队积极备战中',
    time: '2025-04-20 08:30',
    location: '学校操场',
    type: 'success',
    status: '筹备中'
  },
  {
    id: 3,
    title: '学术讲座：人工智能前沿',
    content: '特邀清华大学李教授来校开展人工智能前沿技术讲座',
    time: '2025-05-10 14:00',
    location: '教学楼A101',
    type: 'warning',
    status: '即将开始'
  }
])

// 食堂信息
const canteenInfo = ref([
  {
    name: '第一食堂',
    floor: '1-2层',
    businessHours: '07:00-22:00',
    specialty: '粤式炒粉、烧腊'
  },
  {
    name: '第二食堂',
    floor: '3层',
    businessHours: '06:30-21:30',
    specialty: '川湘菜、面食'
  },
  {
    name: '国际餐厅',
    floor: '4层',
    businessHours: '10:00-20:00',
    specialty: '西餐、日料'
  }
])

// 查看新闻详情
const showNewsDetail = (news) => {
  // TODO: 显示新闻详情
  console.log('查看新闻:', news.title)
}
</script>

<style scoped>
.campus-life-container {
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

/* 主要内容区域样式 */
.main-content {
  flex: 1;
  padding: 20px 5%;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.section-header h2 {
  font-size: 22px;
  color: #303133;
  margin: 0;
}

/* 校园新闻部分 */
.news-section {
  margin-bottom: 40px;
  background: #fff;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
}

.news-card {
  margin-bottom: 20px;
  transition: all 0.3s;
  border-radius: 8px;
  overflow: hidden;
}

.news-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 6px 16px 0 rgba(0, 0, 0, 0.1);
}

.news-image {
  width: 100%;
  height: 180px;
  object-fit: cover;
  transition: transform 0.3s;
}

.news-card:hover .news-image {
  transform: scale(1.03);
}

.news-info {
  padding: 15px;
}

.news-info h3 {
  margin: 0 0 10px 0;
  font-size: 16px;
  color: #303133;
  font-weight: 500;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.news-info p {
  margin: 0 0 10px 0;
  font-size: 14px;
  color: #606266;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  overflow: hidden;
  height: 42px;
}

.bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 10px;
  font-size: 12px;
  color: #909399;
}

/* 校园活动部分 */
.activities-section {
  margin-bottom: 40px;
  background: #fff;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
}

.el-timeline {
  padding-left: 10px;
}

.el-timeline-item__wrapper {
  padding-left: 20px;
  padding-bottom: 20px;
}

.el-timeline-item__timestamp {
  color: #606266;
  font-size: 14px;
  margin-bottom: 8px;
}

.activity-location {
  display: flex;
  align-items: center;
  color: #606266;
  font-size: 14px;
  margin: 8px 0;
}

.activity-location .el-icon {
  margin-right: 5px;
}

.activity-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 10px;
}

/* 食堂信息部分 */
.canteen-section {
  background: #fff;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
  margin-bottom: 40px;
}

.el-table {
  margin-top: 20px;
  border-radius: 8px;
  overflow: hidden;
}

.el-table th {
  background-color: #f5f7fa;
  font-weight: 500;
}

/* 响应式设计 */
@media (max-width: 992px) {
  .header {
    padding: 0 20px;
  }
  
  .nav {
    margin: 0 20px;
  }
}

@media (max-width: 768px) {
  .header {
    padding: 0 15px;
  }
  
  .logo span {
    display: none;
  }
  
  .nav {
    margin: 0 10px;
  }
  
  .el-menu--horizontal {
    white-space: nowrap;
    overflow-x: auto;
    padding-bottom: 5px;
  }
  
  .el-menu-item {
    padding: 0 8px;
    font-size: 14px;
  }
  
  .username {
    display: none;
  }
  
  .main-content {
    padding: 15px;
  }
  
  .section-header h2 {
    font-size: 18px;
  }
}

@media (max-width: 576px) {
  .news-info h3 {
    font-size: 15px;
  }
  
  .news-info p {
    font-size: 13px;
  }
  
  .el-timeline-item__timestamp {
    font-size: 13px;
  }
}
</style>