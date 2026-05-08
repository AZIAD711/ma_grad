import { Project } from "../../model/project.model.js"
// ADD A NEW PROJECT 
export const addProjectService = async(data)=>{
    return await Project.create(data)
}
