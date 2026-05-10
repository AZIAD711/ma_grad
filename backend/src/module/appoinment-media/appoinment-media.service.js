import { AppoinmentMedia } from "../../model/appoinment-media.model.js"

// ADD A NEW APPOINMENT MEDIA  
export const addAppoinmentMediaService = async(data)=>{
    return await AppoinmentMedia.create(data)
}
// GET ALL APPOINMENT MEDIA  
export const getAllAppoinmentMediasService = async()=>{
    return await AppoinmentMedia.findAll()
}