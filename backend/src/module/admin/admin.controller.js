import {addAdminService,getAllAdminsService,getAdminByIdService,updateAdminService,deleteAdminService} from "./admin.service.js"
// ADD NEW ADMIN 
export const addAdminController = async(request,response)=>{
    try {
        const adminBody = request.body
        const newAdmin = await addAdminService(adminBody)
        return response.status(201).json({
            "message":"admin added successfully",
            "data":newAdmin
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// GET ALL ADMINS 
export const getAllAdminsContoller = async(request,response)=>{
    try {
        const admins = await getAllAdminsService()
        return response.status(200).json({
            "message":"admins fetched successfully",
            "data":admins
        })
    } catch (error) {
                console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// GET ADMIN BY ID 
export const getAdminByIdContoller = async(request,response)=>{
    try {
        const adminId = request.params.id
        const admins = await getAdminByIdService(adminId)
        return response.status(200).json({
            "message":"admin fetched successfully",
            "data":admins
        })
    } catch (error) {
                console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// UPDATE ADMIN DATA 
export const updateAdminContoller = async(request,response)=>{
    try {
        const adminId = request.params.id
        const adminnBody = request.body
        const admins = await updateAdminService(adminnBody,adminId)
        return response.status(200).json({
            "message":"admin updated successfully",
            "data":admins
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// DELETE ADMIN DATA 
export const deleteAdminContoller = async(request,response)=>{
    try {
        const adminId = request.params.id
        const admins = await deleteAdminService(adminId)
        return response.status(200).json({
            "message":"admin deleted successfully",
            "data":admins
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}