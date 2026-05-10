import { Notification } from "../../model/notification.model.js"
// ADD A NEW NOTIFICATION 
export const addNotificationService = async(data)=>{
    return await Notification.create(data)
}// GET ALL NOTIFICATIONS 
export const getAllNotificationsService = async()=>{
    return await Notification.findAll()
}