import { Project } from "../../model/project.model.js"
// ADD A NEW PROJECT 
export const addProjectService = async(data)=>{
    return await Project.create(data)
}
// GET ALL PROJECTS 
export const getAllProjectssService = async()=>{
    return await Project.findAll()
}