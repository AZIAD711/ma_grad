import {addNotificationService,getAllNotificationsService} from "./notification.service.js"
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