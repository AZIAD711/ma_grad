import { addProjectService, getAllProjectssService, getProjectByIdService ,updateProjectService,deleteProjectService} from "./project.service.js"
// ADD NEW USER 
export const addProjectController = async (request, response) => {
    try {
        const projectBody = request.body
        const newProject = await addProjectService(projectBody)
        return response.status(201).json({
            "message": "project added successfully",
            "data": newProject
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage": "something went wrong"
        })
    }
}
// GET ALL PROJECTS 
export const getAllProjectsContoller = async (request, response) => {
    try {
        const projects = await getAllProjectssService()
        return response.status(200).json({
            "message": "projects fetched successfully",
            "data": projects
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage": "something went wrong"
        })
    }
}
// GET PROJECT BY ID 
export const getProjectByIdContoller = async (request, response) => {
    try {
        const projectId = request.params.id
        const projects = await getProjectByIdService(projectId)
        return response.status(200).json({
            "message": "project fetched successfully",
            "data": projects
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage": "something went wrong"
        })
    }
}
// UPDATE PROJECT DATA 
export const updateProjectContoller = async (request, response) => {
    try {
        const projectId = request.params.id
        const projectBody = request.body
        const project = await updateProjectService(projectBody, projectId)
        return response.status(200).json({
            "message": "project updated successfully",
            "data": project
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage": "something went wrong"
        })
    }
}
// DELETE PROJECT DATA 
export const deleteProjectContoller = async(request,response)=>{
    try {
        const projectId = request.params.id
        const projects = await deleteProjectService(projectId)
        return response.status(200).json({
            "message":"project deleted successfully",
            "data":projects
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
