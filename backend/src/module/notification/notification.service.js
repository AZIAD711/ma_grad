import { Notification } from "../../model/notification.model.js"
// ADD A NEW NOTIFICATION 
export const addNotificationService = async(data)=>{
    return await Notification.create(data)
}// GET ALL NOTIFICATIONS 
export const getAllNotificationsService = async()=>{
    return await Notification.findAll()
}
// GET NOTIFICATION BY ID 
export const getNotificationByIdService = async(id)=>{
    return await Notification.findByPk(id)
}
// UPDATE NOTIFICATION DATA 
export const updateNotificationService = async(data,id)=>{
    return await Notification.update(data,{
        where:{
            notificationId:id
        }
    })
}
// DELETE NOTIFICATION DATA 
export const deleteNotificationService = async(id)=>{
    return await Notification.destroy({
        where:{
            notificationId:id
        }
    })
}