import {addProjectService} from "./project.service.js"
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
