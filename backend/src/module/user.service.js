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
// UPDATE USER DATA 
export const updateUserService = async(data,id)=>{
    return await User.update(data,{
        where:{
            userId:id
        }
    })
}
// DELETE USER DATA 
export const deleteUserService = async(id)=>{
    return await User.destroy({
        where:{
            userId:id
        }
    })
}