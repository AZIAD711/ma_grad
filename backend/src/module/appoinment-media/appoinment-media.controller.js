import {addAppoinmentMediaService} from "./appoinment-media.service.js"
// ADD NEW USER 
export const addUserController = async(request,response)=>{
    try {
        const appoinmentMediaBody = request.body
        const newAppoinmentMedia = await addAppoinmentMediaService(appoinmentMediaBody)
        return response.status(201).json({
            "message":"appoinment media added successfully",
            "data":newAppoinmentMedia
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}