import { AdminFeatures } from "../../model/admin.features.model.js"
// ADD ADMIN FEATURES 
export const addAdminFeaturesService = async(data)=>{
    return await AdminFeatures.create(data)
}
// GET ALL ADMINS FEATURES 
export const getAllAdminFeatureService = async()=>{
    return await AdminFeatures.findAll()
}
// GET ADMIN FEATURES  BY ID 
export const getAdminFeatureByIdService = async(id)=>{
    return await AdminFeatures.findByPk(id)
}
// UPDATE ADMIN FEATURES DATA 
export const updateAdminFeaturesService = async(data,id)=>{
    return await AdminFeatures.update(data,{
        where:{
            adminId:id
        }
    })
}
// DELETE ADMIN FEATURES DATA 
export const deleteAdminFeaturesService = async(id)=>{
    return await AdminFeatures.destroy({
        where:{
            adminId:id
        }
    })
}