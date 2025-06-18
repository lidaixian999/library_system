import { useRouter } from 'vue-router'

export const useNavigation = () => {
    const router = useRouter()

    const handleSelect = (key) => {
        switch (key) {
            case 'home_user': return router.push('/home_user')
            case 'library_user': return router.push('/library_user')
            case 'resources_user': return router.push('/resources_user')
            case 'campus_life': return router.push('/campus_life')
            case 'about_me': return router.push('/about_me')

            case 'home_controller': return router.push('/home_controller')
            case 'library_controller': return router.push('/library_controller')
            case 'borrow_admin': return router.push('/borrow_admin')
            case 'resources_admin': return router.push('/resources_admin')
            
            default: return router.push('/login')
        }
    }

    return { handleSelect }
}