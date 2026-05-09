import { AdminFeatures } from "../../model/admin.features.model.js"
// ADD ADMIN FEATURES 
export const addAdminFeaturesService = async(data)=>{
    return await AdminFeatures.create(data)
}