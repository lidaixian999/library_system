import { useRouter } from 'vue-router'

export const useNavigation = () => {
    const router = useRouter()

    const handleSelect = (key) => {
        switch (key) {
            case '1': return router.push('/home_user')
            case '2': return router.push('/library_user')
            case '3': return router.push('/resources_user')
            case '4': return router.push('/campus_life')
            case '5': return router.push('/about')
            default: return router.push('/home_user')
        }
    }

    return { handleSelect }
}