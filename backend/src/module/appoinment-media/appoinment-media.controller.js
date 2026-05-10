import {addAppoinmentMediaService,getAllAppoinmentMediasService} from "./appoinment-media.service.js"
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
// GET ALL APPOINMENT MEDIA  
export const getAllAppoinmentMediaContoller = async(request,response)=>{
    try {
        const appoinmentMedia = await getAllAppoinmentMediasService()
        return response.status(200).json({
            "message":"appoinment media fetched successfully",
            "data":appoinmentMedia
        })
    } catch (error) {
                console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}