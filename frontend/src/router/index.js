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
import Ownpeople from '../ownpeople.vue'
import About_me from '../views/user/about_me.vue' // 确保路径正确
import borrow_admin from '@/views/admin/borrow_admin.vue'
import resources_admin from '@/views/admin/resources_admin.vue'
import campus_life from '@/views/user/campus_life_user.vue'
import campus_life_admin from '@/views/admin/campus_life_admin.vue'
import about_me_admin from '@/views/admin/about_me.vue'
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
        path:'/ownpeople',
        name:'ownpeople',
        component: Ownpeople
    },{
        path:'/about_me',
        name:'About_me',
        component: About_me
    },{
        path:'/borrow_admin',
        name:'borrow_admin',
        component: borrow_admin
    },{
        path:'/resources_admin',
        name:'resources_admin',
        component: resources_admin
    },{
        path:'/campus_life',
        name:'campus_life',
        component: campus_life
    },{
        path:'/campus_life_admin',
        name:'campus_life_admin',
        component: campus_life_admin
    },{
        path:'/about_me_admin',
        name:'about_me_admin',
        component: about_me_admin
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

export default router