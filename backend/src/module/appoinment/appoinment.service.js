import { Appoinment } from "../../model/appoinment.model.js"

// ADD A NEW APPOINMENT 
export const addAppoinmentService = async(data)=>{
    return await Appoinment.create(data)
}
// GET ALL APPOINMENT 
export const getAllAppoinmentService = async()=>{
    return await Appoinment.findAll()
}
// GET APPOINMENT BY ID 
export const getAppoinmentByIdService = async(id)=>{
    return await Appoinment.findByPk(id)
}