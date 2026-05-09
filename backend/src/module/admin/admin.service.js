import { Admin } from "../../model/admin.model.js"

// ADD A NEW ADMIN 
export const addAdminService = async(data)=>{
    return await Admin.create(data)
}