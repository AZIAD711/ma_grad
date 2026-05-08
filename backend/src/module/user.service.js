import { User } from "../model/user.model.js"
// ADD A NEW USER 
export const addUserService = async(data)=>{
    return await User.create(data)
}
// GET ALL USERS 
export const getAllUsersService = async()=>{
    return await User.findAll()
}
// GET USER BY ID 
export const getUserByIdService = async(id)=>{
    return await User.findByPk(id)
}