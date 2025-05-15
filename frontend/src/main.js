import './assets/main.css'
import { createApp } from 'vue'
import App from './App.vue'  // 使用App作为根组件
import router from './router'
import ElementPlus from 'element-plus'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import 'element-plus/dist/index.css'
import Login from './Login.vue'
const app = createApp(App)  // 使用App作为根组件

// 注册Element Plus
app.use(ElementPlus)

// 注册所有图标组件
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
    app.component(key, component)
}

// 使用路由
app.use(router)

app.mount('#App')  // 挂载到标准的#app元素