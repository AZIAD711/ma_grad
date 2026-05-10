import { Notification } from "../../model/notification.model.js"
// ADD A NEW NOTIFICATION 
export const addNotificationService = async(data)=>{
    return await Notification.create(data)
}