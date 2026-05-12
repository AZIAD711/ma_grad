import { Admin } from "../../model/admin.model.js"
import { Client } from "../../model/client.model.js"
import { User } from "../../model/user.model.js"
import { Worker } from "../../model/worker.model.js"
// ADD A NEW USER 
export const registerService = async(data)=>{
    const userData= await User.create(data)
    // CHECK ROLE
    // CLIENT
    if (data.role === "client") {

        await Client.create({
            userId: userData.userId,
            gender: data.gender,
            salary: data.salary,
            incomeLevel: data.incomeLevel
        })

    }
    // WORKER
     else if (data.role === "worker") {
        await Worker.create({
            userId: userData.userId,
            natiolityId: data.natiolityId,
            location: data.location,
            jobTitle: data.jobTitle
        })
    }
    // ADMIN
    else if (data.role === "admin") {
        await Admin.create({
            userId: userData.userId,
            authorityLevel: data.authorityLevel
        })
    }
    return userData
    
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
// LOGIN BY EMAIL AND PASSWORD 
export const loginUserService= async (email,password)=>{
    const userData = await User.findOne({
        where:{
            email:email,
            password:password
        }
    })
    // if(!userData){
    //     throw new Error("Email or password is incorrect");
    // }
    return userData
}