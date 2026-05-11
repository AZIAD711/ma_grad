import {addNotificationService,getAllNotificationsService,getNotificationByIdService,updateNotificationService} from "./notification.service.js"
// ADD NEW NOTIFICATION 
export const addOrderController = async(request,response)=>{
    try {
        const notifcationBody = request.body
        const notifcation = await addNotificationService(notifcationBody)
        return response.status(201).json({
            "message":"notifcation added successfully",
            "data":notifcation
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// GET ALL NOTIFICATIONS 
export const getAllNotificationsContoller = async(request,response)=>{
    try {
        const notifications = await getAllNotificationsService()
        return response.status(200).json({
            "message":"notifications fetched successfully",
            "data":notifications
        })
    } catch (error) {
                console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// GET NOTIFICATION BY ID 
export const getNotificationByIdContoller = async(request,response)=>{
    try {
        const notificationId = request.params.id
        const notification = await getNotificationByIdService(notificationId)
        return response.status(200).json({
            "message":"notification fetched successfully",
            "data":notification
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// UPDATE NOTIFICATION DATA 
export const updateNotificationContoller = async(request,response)=>{
    try {
        const notificationId = request.params.id
        const notificationBody = request.body
        const notifcations = await updateNotificationService(notificationBody,notificationId)
        return response.status(200).json({
            "message":"notification updated successfully",
            "data":notifcations
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}