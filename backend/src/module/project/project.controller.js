import {addProjectService,getAllProjectssService} from "./project.service.js"
// ADD NEW USER 
export const addProjectController = async(request,response)=>{
    try {
        const projectBody = request.body
        const newProject = await addProjectService(projectBody)
        return response.status(201).json({
            "message":"project added successfully",
            "data":newProject
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// GET ALL PROJECTS 
export const getAllProjectsContoller = async(request,response)=>{
    try {
        const projects = await getAllProjectssService()
        return response.status(200).json({
            "message":"projects fetched successfully",
            "data":projects
        })
    } catch (error) {
                console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
