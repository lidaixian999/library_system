// src/router/index.js
import { createRouter, createWebHistory } from 'vue-router'
import Login from '../Login.vue' // 确保路径正确
import Home_contorller from '../views/admin/Home_contorller.vue' // 确保路径正确
import Register from '../Register.vue' // 确保路径正确
import Library_controller from '../views/admin/Libaray_controller.vue' // 确保路径正确
import Home_user from '../views/user/Home_user.vue' // 确保路径正确
import Library_user from '../views/user/library_user.vue' // 确保路径正确
import Borrow_user from '../views/user/borrow_user.vue' // 确保路径正确
import Resources_user from '../views/user/resources_user.vue' // 确保路径正确
import People_user from '../views/user/user_people.vue' // 确保路径正确
const routes = [
    {
        path: '/',
        redirect: '/login'
    },
    {
        path: '/login',
        name: 'Login',
        component: Login
    },
    {
        path: '/home_controller',
        name: 'Home_controller',
        component: Home_contorller
    },
    {
        path:'/home_user',
        name: 'Home_user',
        component: Home_user
    },
    {
        path: '/register',
        name: 'Register',
        component: Register 
    },{
        path: '/library_controller',
        name: 'Library_controller',
        component: Library_controller
    },{
        path:'/library_user',
        name: 'Library_user',
        component: Library_user
    },{
        path:'/borrow_user',
        name:'Borrow_user',
        component: Borrow_user
    },{
        path:'/resources_user',
        name:'Resources_user',
        component: Resources_user
    },{
        path:'/user_people',
        name:'People_user',
        component: People_user
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

export default router