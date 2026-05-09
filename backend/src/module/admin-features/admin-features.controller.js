import {addAdminFeaturesService,getAllAdminFeatureService,getAdminFeatureByIdService,updateAdminFeaturesService} from "./admin-features.service.js"
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
// GET ALL ADMINN FEATURES  
export const getAllAdminFeaturesContoller = async(request,response)=>{
    try {
        const adminFeatures = await getAllAdminFeatureService()
        return response.status(200).json({
            "message":"admin features fetched successfully",
            "data":adminFeatures
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// GET ADMIN FEATURES BY ID 
export const getAdminFeaturesByIdContoller = async(request,response)=>{
    try {
        const adminFeaturesId = request.params.id
        const adminFeatures = await getAdminFeatureByIdService(adminFeaturesId)
        return response.status(200).json({
            "message":"admin features fetched successfully",
            "data":adminFeatures
        })
    } catch (error) {
                console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// UPDATE ADMIN FEATURES DATA 
export const updateAdminFeaturesContoller = async(request,response)=>{
    try {
        const adminFeaturesId = request.params.id
        const adminFeaturesBody = request.body
        const adminFeatures = await updateAdminFeaturesService(adminFeaturesBody,adminFeaturesId)
        return response.status(200).json({
            "message":"admin features updated successfully",
            "data":adminFeatures
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}