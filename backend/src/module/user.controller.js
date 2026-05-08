import {addUserService,getAllUsersService,getUserByIdService,updateUserService} from "./user.service.js"
// ADD NEW USER 
export const addUserController = async(request,response)=>{
    try {
        const userBody = request.body
        const newUser = await addUserService(userBody)
        return response.status(201).json({
            "message":"user added successfully",
            "data":newUser
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// GET ALL USERS 
export const getAllUsersContoller = async(request,response)=>{
    try {
        const users = await getAllUsersService()
        return response.status(200).json({
            "message":"users fetched successfully",
            "data":users
        })
    } catch (error) {
                console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// GET USER BY ID 
export const getUserByIdContoller = async(request,response)=>{
    try {
        const userId = request.params.id
        const users = await getUserByIdService(userId)
        return response.status(200).json({
            "message":"user fetched successfully",
            "data":users
        })
    } catch (error) {
                console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// UPDATE USER DATA 
export const updateUserContoller = async(request,response)=>{
    try {
        const userId = request.params.id
        const userBody = request.body
        const users = await updateUserService(userBody,userId)
        return response.status(200).json({
            "message":"user updated successfully",
            "data":users
        })
    } catch (error) {
                        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}