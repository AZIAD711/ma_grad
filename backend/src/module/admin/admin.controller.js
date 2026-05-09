import {addAdminService} from "./admin.service.js"
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