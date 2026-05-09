import { ProjectMedia } from "../../model/project-media.model.js"
// ADD A NEW PROJECT MEDIA 
export const addProjectMediaService = async(data)=>{
    return await ProjectMedia.create(data)
}
// GET ALL PROJECT MEDIA  
export const getAllProjectMediasService = async()=>{
    return await ProjectMedia.findAll()
}