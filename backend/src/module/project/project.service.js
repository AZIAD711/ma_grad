import { Project } from "../../model/project.model.js"
// ADD A NEW PROJECT 
export const addProjectService = async(data)=>{
    return await Project.create(data)
}
// GET ALL PROJECTS 
export const getAllProjectssService = async()=>{
    return await Project.findAll()
}
// GET PROJECT BY ID 
export const getProjectByIdService = async(id)=>{
    return await Project.findByPk(id)
}
// UPDATE PROJECT DATA 
export const updateProjectService = async(data,id)=>{
    return await Project.update(data,{
        where:{
            projectId:id
        }
    })
}