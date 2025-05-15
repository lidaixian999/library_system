<template>
    <div class="library-management">
      <!-- 搜索区域 -->
      <div class="search-area" >
        <el-form :inline="true" :model="searchForm" class="search-form">
          <el-form-item label="图书名称">
            <el-input v-model="searchForm.title" placeholder="请输入图书名称" clearable />
          </el-form-item>
          <el-form-item label="作者">
            <el-input v-model="searchForm.author" placeholder="请输入作者" clearable />
          </el-form-item>
          <el-form-item label="ISBN">
            <el-input v-model="searchForm.isbn" placeholder="请输入ISBN" clearable />
          </el-form-item>
          <el-form-item label="分类">
            <el-select v-model="searchForm.category" placeholder="请选择分类" clearable>
              <el-option
                v-for="item in categories"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="handleSearch">搜索</el-button>
            <el-button @click="resetSearch">重置</el-button>
          </el-form-item>
        </el-form>
      </div>
  
      <!-- 操作按钮区域 -->
      <div class="action-area">
        <el-button type="primary" @click="handleAdd">
          <el-icon><Plus /></el-icon> 新增图书
        </el-button>
        <el-button type="danger" :disabled="!selectedBooks.length" @click="handleBatchDelete">
          <el-icon><Delete /></el-icon> 批量删除
        </el-button>
        <el-button type="success" @click="handleExport">
          <el-icon><Download /></el-icon> 导出数据
        </el-button>
      </div>
  
      <!-- 图书列表 -->
      <div class="book-list">
        <el-table
          :data="bookList"
          border
          stripe
          style="width: 100%"
          @selection-change="handleSelectionChange"
        >
          <el-table-column type="selection" width="55" />
          <el-table-column prop="isbn" label="ISBN" width="180" />
          <el-table-column prop="title" label="书名" width="200" />
          <el-table-column prop="author" label="作者" width="120" />
          <el-table-column prop="category" label="分类" width="120">
            <template #default="{ row }">
              <el-tag :type="getCategoryTagType(row.category)">
                {{ getCategoryName(row.category) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="totalCopies" label="总数量" width="80" />
          <el-table-column prop="availableCopies" label="可借数量" width="80" />
          <el-table-column prop="location" label="位置" width="120" />
          <el-table-column label="操作" width="180" fixed="right">
            <template #default="{ row }">
              <el-button size="small" @click="handleEdit(row)">编辑</el-button>
              <el-button size="small" type="danger" @click="handleDelete(row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>
  
      <!-- 分页 -->
      <div class="pagination">
        <el-pagination
          v-model:current-page="pagination.currentPage"
          v-model:page-size="pagination.pageSize"
          :page-sizes="[10, 20, 50, 100]"
          :total="pagination.total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
  
      <!-- 编辑图书对话框 -->
      <!-- 新增/编辑图书对话框 -->
  <el-dialog
    v-model="dialogVisible"
    :title="dialogTitle"
    width="50%"
    :before-close="handleCloseDialog"
  >
    <el-form ref="bookForm" :model="currentBook" :rules="rules" label-width="100px">
      <el-form-item label="ISBN" prop="isbn">
        <el-input v-model="currentBook.isbn" placeholder="请输入ISBN" />
      </el-form-item>
      <el-form-item label="书名" prop="title">
        <el-input v-model="currentBook.title" placeholder="请输入书名" />
      </el-form-item>
      <el-form-item label="作者" prop="author">
        <el-input v-model="currentBook.author" placeholder="请输入作者" />
      </el-form-item>
      <el-form-item label="分类" prop="category">
        <el-select v-model="currentBook.category" placeholder="请选择分类">
          <el-option
            v-for="item in categories"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="总数量" prop="totalCopies">
        <el-input-number v-model="currentBook.totalCopies" :min="1" />
      </el-form-item>
      <el-form-item label="可借数量" prop="availableCopies">
        <el-input-number 
          v-model="currentBook.availableCopies" 
          :min="0" 
          :max="currentBook.totalCopies" 
        />
      </el-form-item>
      <el-form-item label="位置" prop="location">
        <el-input v-model="currentBook.location" placeholder="请输入位置" />
      </el-form-item>
      <el-form-item label="封面" prop="cover">
        <el-upload
          class="avatar-uploader"
          action="#"
          :show-file-list="false"
          :auto-upload="false"
          :on-change="handleCoverChange"
        >
          <img v-if="currentBook.cover" :src="currentBook.cover" class="avatar" />
          <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
        </el-upload>
      </el-form-item>
      <el-form-item label="简介" prop="description">
        <el-input
          v-model="currentBook.description"
          type="textarea"
          :rows="4"
          placeholder="请输入图书简介"
        />
      </el-form-item>
    </el-form>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </span>
    </template>
  </el-dialog>
    </div>
  </template>
  
  <script setup>
  import axios from 'axios'
  import { ref, reactive, onMounted } from 'vue'
  import { ElMessage, ElMessageBox } from 'element-plus'
  import { Plus, Delete, Download } from '@element-plus/icons-vue'
  const bookForm = ref(null)
  // 图书分类选项
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
  
  // 搜索表单
  const searchForm = reactive({
    title: '',
    author: '',
    isbn: '',
    category: ''
  })
  
  // 分页信息
  const pagination = reactive({
    currentPage: 1,
    pageSize: 10,
    total: 0
  })
  
  // 图书列表数据
  const bookList = ref([])
  // 选中的图书
  const selectedBooks = ref([])
  
  // 对话框相关
  const dialogVisible = ref(false)
  const dialogTitle = ref('新增图书')
  const isEditMode = ref(false) // 新增编辑模式标识
  const currentBook = reactive({
  id: '',
  isbn: '',
  title: '',
  author: '',
  category: '',
  totalCopies: 1,
  availableCopies: 1,
  location: '',
  cover: '',
  description: ''
})
  
  // 表单验证规则
  const rules = reactive({
    isbn: [{ required: true, message: '请输入ISBN', trigger: 'blur' }],
    title: [{ required: true, message: '请输入书名', trigger: 'blur' }],
    author: [{ required: true, message: '请输入作者', trigger: 'blur' }],
    category: [{ required: true, message: '请选择分类', trigger: 'change' }],
    totalCopies: [{ required: true, message: '请输入总数量', trigger: 'blur' }],
    availableCopies: [{ required: true, message: '请输入可借数量', trigger: 'blur' }]
  })
  
  // 获取分类名称
  const getCategoryName = (category) => {
    const found = categories.value.find(item => item.value === category)
    return found ? found.label : '未知'
  }
  
  // 获取分类标签类型
  const getCategoryTagType = (category) => {
    const types = ['', 'success', 'info', 'warning', 'danger']
    const index = categories.value.findIndex(item => item.value === category)
    return types[index % types.length] || ''
  }
  
  // 处理选择变化
  const handleSelectionChange = (selection) => {
    selectedBooks.value = selection
  }
  
  // 处理分页大小变化
  const handleSizeChange = (size) => {
    pagination.pageSize = size
    fetchBooks()
  }
  
  // 处理当前页变化
  const handleCurrentChange = (page) => {
    pagination.currentPage = page
    fetchBooks()
  }
  
  // 搜索图书
  const handleSearch = () => {
    pagination.currentPage = 1
    fetchBooks()
  }
  
  // 重置搜索
  const resetSearch = () => {
    Object.keys(searchForm).forEach(key => {
      searchForm[key] = ''
    })
    handleSearch()
  }
  
  // 新增图书
  const handleAdd = () => {
    dialogTitle.value = '新增图书'
    isEditMode.value = false
    resetCurrentBook()
    dialogVisible.value = true
  }
  
  // 重置当前图书表单
  const resetCurrentBook = () => {
    Object.keys(currentBook).forEach(key => {
      if (key === 'totalCopies') {
        currentBook[key] = 1
      } else if (key === 'availableCopies') {
        currentBook[key] = 1
      } else {
        currentBook[key] = ''
      }
    })
  }
  
  // 编辑图书
  const handleEdit = (row) => {
    dialogTitle.value = '编辑图书'
    isEditMode.value = true
    // 深拷贝图书数据到currentBook
    Object.keys(currentBook).forEach(key => {
      currentBook[key] = row[key]
    })
    dialogVisible.value = true
  }
  
  // 删除图书
  const handleDelete = async (row) => {
    try {
      await ElMessageBox.confirm('确定要删除该图书吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })
      
      await axios.delete(`http://localhost:8989/api/books/${row.id}`)
      ElMessage.success('删除成功')
      fetchBooks()
    } catch (error) {
      if (error !== 'cancel') {
        ElMessage.error('删除失败')
      } else {
        ElMessage.info('已取消删除')
      }
    }
  }
  
  // 批量删除
  const handleBatchDelete = async () => {
    try {
      await ElMessageBox.confirm(`确定要删除选中的 ${selectedBooks.value.length} 本图书吗?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })
      
      const ids = selectedBooks.value.map(book => book.id)
      await axios.delete('http://localhost:8989/api/books', { data: { ids } })
      
      ElMessage.success('批量删除成功')
      selectedBooks.value = []
      fetchBooks()
    } catch (error) {
      if (error !== 'cancel') {
        ElMessage.error('批量删除失败')
      } else {
        ElMessage.info('已取消删除')
      }
    }
  }
  
  // 导出数据
  const handleExport = () => {
    ElMessage.success('导出成功')
  }
  
  // 处理封面图片变化
  const handleCoverChange = (file) => {
    // 这里简单处理，实际项目中需要上传到服务器
    const reader = new FileReader()
    reader.onload = (e) => {
      currentBook.cover = e.target.result
    }
    reader.readAsDataURL(file.raw)
  }
  
  // 关闭对话框
  const handleCloseDialog = (done) => {
    ElMessageBox.confirm('确定要关闭吗? 未保存的内容将丢失', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }).then(() => {
      done()
    }).catch(() => {
      // 取消关闭
    })
  }
  
  // 提交表单
  const submitForm = async () => {
  bookForm.value.validate(async (valid) => {
    if (!valid) return
    // 如果没有上传封面，cover 设为 null
    if (!currentBook.cover) {
      currentBook.cover = null
    }
    try {
      if (isEditMode.value) {
        await axios.put(`http://localhost:8989/api/books/${currentBook.id}`, currentBook)
        ElMessage.success('更新成功')
      } else {
        await axios.post('http://localhost:8989/api/books', currentBook)
        ElMessage.success('新增成功')
      }
      dialogVisible.value = false
      fetchBooks()
    } catch (err) {
      ElMessage.error('保存失败')
    }
  })
}
  
  // 获取图书列表
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
  .library-management {
    width: 100vw;
    padding: 20px;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    /* 居中 */
    justify-content: center;
    background: #ffffff; /* 浅蓝色背景 */
  }

  .search-area {
    background-color: #f5f7fa;
    padding: 20px;
    margin-bottom: 20px;
    border-radius: 4px;
  }
  
  .search-form {
    display: flex;
    flex-wrap: wrap;
  }
  
  .action-area {
    margin-bottom: 20px;
    display: flex;
    justify-content: flex-start;
    /* 居中 */
    justify-content: center;
    color:aqua;
  }
  
  .book-list {
    margin-bottom: 20px;
    /* 居中 */
    justify-content: center;
  }
  
  .pagination {
    display: flex;
    justify-content: center;
  }
  
  .avatar-uploader {
    border: 1px dashed var(--el-border-color);
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
    width: 178px;
    height: 178px;
  }
  
  .avatar-uploader:hover {
    border-color: var(--el-color-primary);
  }
  
  .avatar-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 178px;
    height: 178px;
    text-align: center;
    line-height: 178px;
  }
  
  .avatar {
    width: 178px;
    height: 178px;
    display: block;
  }
  </style>