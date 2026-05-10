import {addAppoinmentService} from "./appoinment.service.js"
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