import {addProjectMediaService,getAllProjectMediasService,getProjectMediaByIdService,updateProjectMediaService,deleteProjectMediaService} from "./project-media.service.js"
// ADD NEW PROJECT MEDIA  
export const addProjectMediaController = async(request,response)=>{
    try {
        const projectMediaBody = request.body
        const newProjectMedia = await addProjectMediaService(projectMediaBody)
        return response.status(201).json({
            "message":"project media added successfully",
            "data":newProjectMedia
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// GET ALL PROJECT MEDIA 
export const getAllProjectMediaContoller = async(request,response)=>{
    try {
        const projectMedia = await getAllProjectMediasService()
        return response.status(200).json({
            "message":"project media fetched successfully",
            "data":projectMedia
        })
    } catch (error) {
                console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// GET PROJECT MEDIA BY ID 
export const getProjectMediaByIdContoller = async(request,response)=>{
    try {
        const projectMediaId = request.params.id
        const projectMedia = await getProjectMediaByIdService(projectMediaId)
        return response.status(200).json({
            "message":"project media fetched successfully",
            "data":projectMedia
        })
    } catch (error) {
                console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// UPDATE PROJECT MEDIA DATA 
export const updateProjectMediaContoller = async(request,response)=>{
    try {
        const projectMediaId = request.params.id
        const projectMediaBody = request.body
        const projectMedia = await updateProjectMediaService(projectMediaBody,projectMediaId)
        return response.status(200).json({
            "message":"project media updated successfully",
            "data":projectMedia
        })
    } catch (error) {
                        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// DELETE USER DATA 
export const deleteProjectMediaContoller = async(request,response)=>{
    try {
        const projectMediaId = request.params.id
        const projectMedia = await deleteProjectMediaService(projectMediaId)
        return response.status(200).json({
            "message":"user deleted successfully",
            "data":projectMedia
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}