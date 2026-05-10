import {addNotificationService} from "./notification.service.js"
// ADD NEW ORDER 
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