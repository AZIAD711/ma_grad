import { AdminFeatures } from "../../model/admin.features.model.js"
// ADD ADMIN FEATURES 
export const addAdminFeaturesService = async(data)=>{
    return await AdminFeatures.create(data)
}
// GET ALL ADMINS FEATURES 
export const getAllAdminFeatureService = async()=>{
    return await AdminFeatures.findAll()
}