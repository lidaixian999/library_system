<template>
    <div class="register-container">
        <div class="register-box">
            <div class="register-header">
                <h1>深技大图书管理系统</h1>
                <p class="subtitle">深圳技术大学图书馆资源管理平台</p>
            </div>
            <el-form ref="registerFormRef" :model="registerForm" :rules="registerRules" class="register-form" label-position="top">
                <el-form-item label="用户名" prop="username">
                    <el-input v-model="registerForm.username" placeholder="请输入用户名" size="large">
                        <template #prefix>
                            <el-icon>
                                <User />
                            </el-icon>
                        </template>
                    </el-input>
                </el-form-item>
                <el-form-item label="密码" prop="password">
                    <el-input v-model="registerForm.password" type="password" placeholder="请输入密码" size="large"
                        show-password @keyup.enter="handleRegister">
                        <template #prefix>
                            <el-icon>
                                <Lock />
                            </el-icon>
                        </template>
                    </el-input>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" size="large" class="register-btn" :loading="loading" @click="handleRegister">
                        注册
                    </el-button>
                </el-form-item>
                <el-form-item>
                    <el-button type="default" size="large" class="login-btn" @click="goLogin">
                        返回登录
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

const router = useRouter()
const loading = ref(false)
const registerFormRef = ref(null)
const registerForm = reactive({
    username: '',
    password: ''
})
const registerRules = reactive({
    username: [
        { required: true, message: '请输入用户名', trigger: 'blur' },
        { min: 3, max: 20, message: '用户名长度在3到20个字符', trigger: 'blur' }
    ],
    password: [
        { required: true, message: '请输入密码', trigger: 'blur' },
        { min: 6, max: 20, message: '密码长度在6到20个字符', trigger: 'blur' }
    ]
})

const goLogin = () => {
    router.push('/login')
}

const handleRegister = async () => {
    try {
        loading.value = true
        await registerFormRef.value.validate()
        // 模拟注册API调用
        setTimeout(() => {
            ElMessage.success('注册成功，请登录')
            router.push('/login')
        }, 1000)
    } catch (error) {
        ElMessage.error('注册失败，请检查输入')
    } finally {
        loading.value = false
    }
}
</script>

<style scoped>
.register-container {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    width: 100vw;
    background: url('@/assets/photo/library_photo.jpg') no-repeat center center;
    background-size: cover;
    position: relative;
}

.register-container::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 0;
}

.register-box {
    width: 450px;
    padding: 40px;
    background: rgba(255, 255, 255, 0.9);
    border-radius: 8px;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
    z-index: 1;
}

.register-header {
    margin-bottom: 30px;
    text-align: center;
}

.register-header h1 {
    font-size: 24px;
    color: #2c3e50;
    margin-bottom: 8px;
}

.subtitle {
    color: #7f8c8d;
    font-size: 14px;
}

.register-form {
    margin-top: 20px;
}

.register-btn {
    width: 100%;
    height: 48px;
    font-size: 16px;
    margin-top: 0;
}

.login-btn {
    width: 100%;
    margin-top: 10px;
    height: 48px;
    font-size: 16px;
}

/* 响应式设计 */
@media (max-width: 768px) {
    .register-box {
        width: 90%;
        padding: 30px 20px;
    }

    .register-header h1 {
        font-size: 20px;
    }
}
</style>