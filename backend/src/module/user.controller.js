import {addUserService,getAllUsersService} from "./user.service.js"
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