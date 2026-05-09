import { ProjectMedia } from "../../model/project-media.model.js"
// ADD A NEW PROJECT MEDIA 
export const addProjectMediaService = async(data)=>{
    return await ProjectMedia.create(data)
}
// GET ALL PROJECT MEDIA  
export const getAllProjectMediasService = async()=>{
    return await ProjectMedia.findAll()
}
// GET PROJECT MEDIA BY ID 
export const getProjectMediaByIdService = async(id)=>{
    return await ProjectMedia.findByPk(id)
}
// UPDATE USER DATA 
export const updateProjectMediaService = async(data,id)=>{
    return await ProjectMedia.update(data,{
        where:{
            projectMediaId:id
        }
    })
}
// DELETE PROJECT MEDIA DATA 
export const deleteProjectMediaService = async(id)=>{
    return await ProjectMedia.destroy({
        where:{
            projectMediaId:id
        }
    })
}