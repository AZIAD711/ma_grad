import { AppoinmentMedia } from "../../model/appoinment-media.model.js"

// ADD A NEW APPOINMENT MEDIA  
export const addAppoinmentMediaService = async(data)=>{
    return await AppoinmentMedia.create(data)
}
// GET ALL APPOINMENT MEDIA  
export const getAllAppoinmentMediasService = async()=>{
    return await AppoinmentMedia.findAll()
}
// GET APPOINMENT MEDIA  BY ID 
export const getAppoinmentMediaByIdService = async(id)=>{
    return await AppoinmentMedia.findByPk(id)
}
// UPDATE APPOINMENT MEDIA  DATA 
export const updateAppoinmentMediaService = async(data,id)=>{
    return await AppoinmentMedia.update(data,{
        where:{
            appoinmentMediaId:id
        }
    })
}
// DELETE APPOINMENT MEDIA DATA 
export const deleteAppoinmentMediaService = async(id)=>{
    return await AppoinmentMedia.destroy({
        where:{
            appoinmentMediaId:id
        }
    })
}