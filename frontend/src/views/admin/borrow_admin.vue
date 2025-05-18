<template>
  <div class="admin-borrow-container">
    <!-- 顶部导航栏保持不变 -->
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
              <el-dropdown-item>个人中心</el-dropdown-item>
              <el-dropdown-item>系统设置</el-dropdown-item>
              <el-dropdown-item divided @click="logout">退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </header>

    <!-- 主要内容区重构 -->
    <main class="main-content">
      <div class="page-header">
        <h1 class="admin-borrow-title">借阅管理</h1>
        <div class="search-toolbar">
          <el-input
            v-model="searchQuery"
            placeholder="搜索图书名称/用户/编号"
            clearable
            style="width: 300px; margin-right: 10px;"
            @clear="handleSearchClear"
            @keyup.enter="handleSearch"
          />
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </div>
      </div>

      <el-tabs v-model="activeTab" class="borrow-tabs">
        <el-tab-pane label="所有借阅记录" name="all">
          <el-table
            :data="filteredBorrowRecords"
            style="width: 100%"
            stripe
            border
            v-loading="loading"
          >
            <el-table-column prop="recordId" label="记录ID" width="100" sortable />
            <el-table-column prop="username" label="用户名" width="120" sortable />
            <el-table-column prop="bookName" label="图书名称" width="200" sortable />
            <el-table-column prop="bookId" label="图书编号" width="120" sortable />
            <el-table-column prop="borrowDate" label="借出日期" width="150" sortable>
              <template #default="{row}">
                {{ formatDate(row.borrowDate) }}
              </template>
            </el-table-column>
            <el-table-column prop="dueDate" label="应还日期" width="150" sortable>
              <template #default="{row}">
                {{ formatDate(row.dueDate) }}
              </template>
            </el-table-column>
            <el-table-column prop="returnDate" label="归还日期" width="150" sortable>
              <template #default="{row}">
                {{ row.returnDate ? formatDate(row.returnDate) : '未归还' }}
              </template>
            </el-table-column>
            <el-table-column prop="status" label="状态" width="120" sortable>
              <template #default="{row}">
                <el-tag :type="getStatusTagType(row.status)">
                  {{ getStatusText(row.status) }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="180" fixed="right">
              <template #default="{row}">
                <el-button
                  v-if="row.status === 'borrowed'"
                  size="small"
                  type="warning"
                  @click="handleAdminRenew(row)"
                >
                  续借
                </el-button>
                <el-button
                  v-if="row.status === 'borrowed'"
                  size="small"
                  type="danger"
                  @click="handleAdminReturn(row)"
                >
                  归还
                </el-button>
                <el-button
                  size="small"
                  type="info"
                  @click="showRecordDetails(row)"
                >
                  详情
                </el-button>
              </template>
            </el-table-column>
          </el-table>

          <div class="pagination-container">
            <el-pagination
              v-model:current-page="currentPage"
              v-model:page-size="pageSize"
              :total="totalRecords"
              :page-sizes="[10, 20, 50, 100]"
              layout="total, sizes, prev, pager, next, jumper"
              @size-change="handleSizeChange"
              @current-change="handleCurrentChange"
            />
          </div>
        </el-tab-pane>

        <el-tab-pane label="逾期记录" name="overdue">
          <el-table
            :data="overdueRecords"
            style="width: 100%"
            stripe
            border
            v-loading="loading"
          >
            <el-table-column prop="recordId" label="记录ID" width="100" />
            <el-table-column prop="username" label="用户名" width="120" />
            <el-table-column prop="bookName" label="图书名称" width="200" />
            <el-table-column prop="bookId" label="图书编号" width="120" />
            <el-table-column prop="borrowDate" label="借出日期" width="150">
              <template #default="{row}">
                {{ formatDate(row.borrowDate) }}
              </template>
            </el-table-column>
            <el-table-column prop="dueDate" label="应还日期" width="150">
              <template #default="{row}">
                {{ formatDate(row.dueDate) }}
              </template>
            </el-table-column>
            <el-table-column prop="overdueDays" label="逾期天数" width="120" sortable>
              <template #default="{row}">
                <el-tag type="danger">
                  {{ calculateOverdueDays(row.dueDate) }} 天
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="180" fixed="right">
              <template #default="{row}">
                <el-button
                  size="small"
                  type="danger"
                  @click="handleAdminReturn(row)"
                >
                  归还
                </el-button>
                <el-button
                  size="small"
                  type="warning"
                  @click="sendReminder(row)"
                >
                  催还
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </main>

    <!-- 页脚保持不变 -->
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

    <!-- 借阅记录详情对话框 -->
    <el-dialog
      v-model="detailDialogVisible"
      title="借阅记录详情"
      width="50%"
    >
      <el-descriptions :column="2" border>
        <el-descriptions-item label="记录ID">{{ currentRecord.recordId }}</el-descriptions-item>
        <el-descriptions-item label="用户名">{{ currentRecord.username }}</el-descriptions-item>
        <el-descriptions-item label="图书名称">{{ currentRecord.bookName }}</el-descriptions-item>
        <el-descriptions-item label="图书编号">{{ currentRecord.bookId }}</el-descriptions-item>
        <el-descriptions-item label="借出日期">{{ formatDate(currentRecord.borrowDate) }}</el-descriptions-item>
        <el-descriptions-item label="应还日期">{{ formatDate(currentRecord.dueDate) }}</el-descriptions-item>
        <el-descriptions-item label="归还日期">
          {{ currentRecord.returnDate ? formatDate(currentRecord.returnDate) : '未归还' }}
        </el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="getStatusTagType(currentRecord.status)">
            {{ getStatusText(currentRecord.status) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="逾期天数" v-if="isOverdue(currentRecord.dueDate)">
          <el-tag type="danger">
            {{ calculateOverdueDays(currentRecord.dueDate) }} 天
          </el-tag>
        </el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="detailDialogVisible = false">关闭</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 续借对话框 -->
    <el-dialog
      v-model="renewDialogVisible"
      title="续借图书"
      width="30%"
    >
      <el-form :model="renewForm" label-width="100px">
        <el-form-item label="图书名称">
          <el-input v-model="renewForm.bookName" disabled />
        </el-form-item>
        <el-form-item label="当前应还日期">
          <el-input v-model="renewForm.currentDueDate" disabled />
        </el-form-item>
        <el-form-item label="续借时长">
          <el-select v-model="renewForm.duration" placeholder="请选择续借时长">
            <el-option :value="7" label="1周" />
            <el-option :value="14" label="2周" />
            <el-option :value="30" label="1个月" />
            <el-option :value="60" label="2个月" />
          </el-select>
        </el-form-item>
        <el-form-item label="新应还日期">
          <el-input v-model="renewForm.newDueDate" disabled />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="renewDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="confirmRenew">确认续借</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import axios from 'axios'
import userAvatar from '@/assets/photo/user.png'


const router = useRouter()
const route = useRoute()

// 导航菜单
const activeIndex = computed(() => route.path)
const handleSelect = (index) => {
  router.push(index)
}
const userAvatarref = ref(userAvatar)

// 借阅数据
const activeTab = ref('all')
const loading = ref(false)
const searchQuery = ref('')
const currentPage = ref(1)
const pageSize = ref(10)
const totalRecords = ref(0)
const allBorrowRecords = ref([])
const overdueRecords = ref([])

// 对话框控制
const detailDialogVisible = ref(false)
const renewDialogVisible = ref(false)
const currentRecord = ref({})
const renewForm = ref({
  recordId: '',
  bookName: '',
  currentDueDate: '',
  duration: 30,
  newDueDate: ''
})


// 获取所有借阅记录
const fetchAllBorrowRecords = async () => {
  try {
    loading.value = true
    const response = await axios.get('http://localhost:8989/api/borrow/all', {
      params: {
        page: currentPage.value,
        size: pageSize.value,
        search: searchQuery.value
      }
    })
    allBorrowRecords.value = response.data.records
    totalRecords.value = response.data.total
    overdueRecords.value = response.data.overdue
    loading.value = false
  } catch (error) {
    console.error('获取借阅记录失败:', error)
    ElMessage.error('获取借阅记录失败')
    loading.value = false
  }
}

// 搜索功能
const handleSearch = () => {
  currentPage.value = 1
  fetchAllBorrowRecords()
}

const handleSearchClear = () => {
  searchQuery.value = ''
  handleSearch()
}

const resetSearch = () => {
  searchQuery.value = ''
  currentPage.value = 1
  fetchAllBorrowRecords()
}

// 分页处理
const handleSizeChange = (newSize) => {
  pageSize.value = newSize
  fetchAllBorrowRecords()
}

const handleCurrentChange = (newPage) => {
  currentPage.value = newPage
  fetchAllBorrowRecords()
}

// 过滤后的借阅记录
const filteredBorrowRecords = computed(() => {
  return allBorrowRecords.value
})

// 日期格式化
const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return format(date, 'yyyy-MM-dd HH:mm')
}

// 状态显示
const getStatusText = (status) => {
  const statusMap = {
    borrowed: '借阅中',
    returned: '已归还',
    overdue: '已逾期',
    lost: '已丢失'
  }
  return statusMap[status] || status
}

const getStatusTagType = (status) => {
  const typeMap = {
    borrowed: 'primary',
    returned: 'success',
    overdue: 'danger',
    lost: 'warning'
  }
  return typeMap[status] || ''
}

// 计算逾期天数
const calculateOverdueDays = (dueDate) => {
  if (!dueDate) return 0
  const today = new Date()
  const due = new Date(dueDate)
  const diffTime = today - due
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
  return diffDays > 0 ? diffDays : 0
}

const isOverdue = (dueDate) => {
  return calculateOverdueDays(dueDate) > 0
}

// 显示记录详情
const showRecordDetails = (record) => {
  currentRecord.value = record
  detailDialogVisible.value = true
}

// 管理员续借
const handleAdminRenew = (record) => {
  currentRecord.value = record
  renewForm.value = {
    recordId: record.recordId,
    bookName: record.bookName,
    currentDueDate: formatDate(record.dueDate),
    duration: 30,
    newDueDate: formatDate(new Date(new Date(record.dueDate).getTime() + 30 * 24 * 60 * 60 * 1000))
  }
  renewDialogVisible.value = true
}

// 续借时长变化时更新新应还日期
watch(() => renewForm.value.duration, (newDuration) => {
  if (currentRecord.value.dueDate) {
    const dueDate = new Date(currentRecord.value.dueDate)
    const newDueDate = new Date(dueDate.getTime() + newDuration * 24 * 60 * 60 * 1000)
    renewForm.value.newDueDate = formatDate(newDueDate)
  }
})

// 确认续借
const confirmRenew = async () => {
  try {
    await axios.post('http://localhost:8989/api/admin/borrow/renew', {
      recordId: renewForm.value.recordId,
      duration: renewForm.value.duration
    })
    ElMessage.success('续借成功')
    renewDialogVisible.value = false
    fetchAllBorrowRecords()
  } catch (error) {
    ElMessage.error(error.response?.data?.error || '续借失败')
  }
}

// 管理员归还
const handleAdminReturn = async (record) => {
  try {
    await ElMessageBox.confirm(
      `确认归还图书《${record.bookName}》？`,
      '确认归还',
      {
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    
    await axios.post('http://localhost:8989/api/admin/borrow/return', {
      recordId: record.recordId
    })
    ElMessage.success('归还成功')
    fetchAllBorrowRecords()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('归还失败')
    }
  }
}

// 发送催还通知
const sendReminder = async (record) => {
  try {
    await axios.post('http://localhost:8989/api/admin/borrow/remind', {
      recordId: record.recordId
    })
    ElMessage.success('催还通知已发送')
  } catch (error) {
    ElMessage.error('发送催还通知失败')
  }
}



// 组件挂载时获取数据
onMounted(() => {
  fetchAllBorrowRecords()
})
</script>

<style scoped>
.admin-borrow-container {
  width: 100vw;
  height: 100vh;
  overflow: auto;
  display: flex;
  flex-direction: column;
  background-color: #fff;
}

/* 顶部导航栏样式保持不变 */
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

.admin-borrow-title {
  color: #100404d5;
  font-size: 24px;
}

.search-toolbar {
  display: flex;
  align-items: center;
}

.borrow-tabs {
  margin-top: 20px;
}

.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

/* 页脚样式保持不变 */
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
  
  .page-header {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .search-toolbar {
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