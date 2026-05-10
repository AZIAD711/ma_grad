import {addAppoinmentService,getAllAppoinmentService,getAppoinmentByIdService,updateAppoinmentService} from "./appoinment.service.js"
// ADD NEW APPOINMENT 
export const addAppoinmentController = async(request,response)=>{
    try {
        const appoinmentBody = request.body
        const newAppoinment = await addAppoinmentService(appoinmentBody)
        return response.status(201).json({
            "message":"appoinment added successfully",
            "data":newAppoinment
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// GET ALL APPOINMENT 
export const getAllAppoinmentContoller = async(request,response)=>{
    try {
        const appoinment = await getAllAppoinmentService()
        return response.status(200).json({
            "message":"appoinments fetched successfully",
            "data":appoinment
        })
    } catch (error) {
                console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// GET APPOINMENT BY ID 
export const getAppoinmentByIdContoller = async(request,response)=>{
    try {
        const appoinmentId = request.params.id
        const appoinments = await getAppoinmentByIdService(appoinmentId)
        return response.status(200).json({
            "message":"appoinment fetched successfully",
            "data":appoinments
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// UPDATE APPOINMENT DATA 
export const updateAppoinmentContoller = async(request,response)=>{
    try {
        const appoinmentId = request.params.id
        const appoinmentBody = request.body
        const appoinments = await updateAppoinmentService(appoinmentBody,appoinmentId)
        return response.status(200).json({
            "message":"appoinment updated successfully",
            "data":appoinments
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}