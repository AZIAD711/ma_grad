import {addAdminFeaturesService} from "./admin-features.service.js"
// ADD NEW ADMIN FEATURES 
export const addAdminFeaturesController = async(request,response)=>{
    try {
        const adminFeaturesBody = request.body
        const newAdminFeatures = await addAdminFeaturesService(adminFeaturesBody)
        return response.status(201).json({
            "message":"admin features added successfully",
            "data":newAdminFeatures
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}