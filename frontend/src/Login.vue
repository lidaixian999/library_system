<template>
    <div class="login-container">
        <div class="login-box">
            <div class="login-header">
                <h1>深技大图书管理系统</h1>
                <p class="subtitle">深圳技术大学图书馆资源管理平台</p>
            </div>

            <el-form ref="loginFormRef" :model="loginForm" :rules="loginRules" class="login-form" label-position="top">
                <el-form-item label="用户名" prop="username">
                    <el-input v-model="loginForm.username" placeholder="请输入用户名" size="large">
                        <template #prefix>
                            <el-icon>
                                <User />
                            </el-icon>
                        </template>
                    </el-input>
                </el-form-item>

                <el-form-item label="密码" prop="password">
                    <el-input v-model="loginForm.password" type="password" placeholder="请输入密码" size="large"
                        show-password @keyup.enter="handleLogin">
                        <template #prefix>
                            <el-icon>
                                <Lock />
                            </el-icon>
                        </template>
                    </el-input>
                </el-form-item>

                <el-form-item>
                    <el-button type="primary" size="large" class="login-btn" :loading="loading" @click="handleLogin">
                        登 录
                    </el-button>
                </el-form-item>
                <el-form-item>
                    <el-button type="default" size="large" class="register-btn" @click="goRegister">
                        注册
                    </el-button>
                </el-form-item>
            </el-form>
        </div>
    </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Lock } from '@element-plus/icons-vue'
import axios from 'axios'

const router = useRouter()
const goRegister = () =>{
    router.push('/register')
}
// 登录表单数据
const loginForm = reactive({
    username: '',
    password: ''
})

// 表单验证规则
const loginRules = reactive({
    username: [
        { required: true, message: '请输入用户名', trigger: 'blur' },
        { min: 3, max: 20, message: '用户名长度在3到20个字符', trigger: 'blur' }
    ],
    password: [
        { required: true, message: '请输入密码', trigger: 'blur' },
        { min: 3, max: 20, message: '密码长度在3到20个字符', trigger: 'blur' }
    ]
})

const loading = ref(false)
const loginFormRef = ref(null)

//登录处理
const handleLogin = async () => {
  try {
    loading.value = true
    await loginFormRef.value.validate()

    // const response = await axios.post('http://localhost:8989/api/users/login', {
    //   username: loginForm.username,
    //   password: loginForm.password
    // })

    // ElMessage.success('登录成功')
    // const user = response.data.user

    // 保存用户信息（根据你的需要是否存储）
    // localStorage.setItem('userInfo', JSON.stringify(user))

    // 根据用户名判断是否是管理员
    if (loginForm.username.toLowerCase() === 'admin') {
      router.push('/home_controller')
    } else {
      router.push('/home_user')
    }
  } catch (error) {
    ElMessage.error('用户名或密码错误')
  } finally {
    loading.value = false
  }
}
// const handleLogin = async () => {
//   try {
//     loading.value = true
//     await loginFormRef.value.validate()

//     const response = await axios.post('http://localhost:8989/api/users/login', {
//       username: loginForm.username,
//       password: loginForm.password
//     })

//     const user = response.data.user
//     ElMessage.success('登录成功')
    
//     // 保存用户信息
//     localStorage.setItem('userInfo', JSON.stringify(user))

//     // 根据用户角色跳转不同页面
//     if (user.role === 'admin') {
//       router.push('/home_controller')
//     } else {
//       router.push('/home_user')
//     }
//   } catch (error) {
//     ElMessage.error(error.response?.data?.message || '用户名或密码错误')
//   } finally {
//     loading.value = false
//   }
// }
</script>


<style scoped>
.login-container {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    width: 100vw;
    background: url('@/assets/photo/library_photo.jpg') no-repeat center center;
    background-size: cover;
    position: relative;
}

.login-container::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    /* 半透明黑色遮罩 */
    z-index: 0;
}

.login-box {
    width: 450px;
    padding: 40px;
    background: rgba(255, 255, 255, 0.9);
    border-radius: 8px;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
    z-index: 1;
}
.register-btn {
    width: 100%;
    height: 48px;
    font-size: 16px;
    margin-top: 0;
}
.login-header {
    margin-bottom: 30px;
    text-align: center;
}

.login-header h1 {
    font-size: 24px;
    color: #2c3e50;
    margin-bottom: 8px;
}

.subtitle {
    color: #7f8c8d;
    font-size: 14px;
}

.login-form {
    margin-top: 20px;
}

.login-btn {
    width: 100%;
    margin-top: 10px;
    height: 48px;
    font-size: 16px;
}

/* 响应式设计 */
@media (max-width: 768px) {
    .login-box {
        width: 90%;
        padding: 30px 20px;
    }

    .login-header h1 {
        font-size: 20px;
    }
}
</style>