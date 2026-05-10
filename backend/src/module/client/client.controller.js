import {addClientService,getAllClientsService,getClientByIdService,updateClientService,deleteClientService} from "./client.service.js"
// ADD NEW CLIENT 
export const addClientController = async(request,response)=>{
    try {
        const clientBody = request.body
        const newClient = await addClientService(clientBody)
        return response.status(201).json({
            "message":"client added successfully",
            "data":newClient
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// GET ALL CLIENTS 
export const getAllClientsContoller = async(request,response)=>{
    try {
        const clients = await getAllClientsService()
        return response.status(200).json({
            "message":"clients fetched successfully",
            "data":clients
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// GET CLEINT BY ID 
export const getClientByIdContoller = async(request,response)=>{
    try {
        const clientId = request.params.id
        const clients = await getClientByIdService(clientId)
        return response.status(200).json({
            "message":"client fetched successfully",
            "data":clients
        })
    } catch (error) {
                console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// UPDATE CLIENT DATA 
export const updateClientContoller = async(request,response)=>{
    try {
        const clientId = request.params.id
        const clientBody = request.body
        const clients = await updateClientService(clientBody,clientId)
        return response.status(200).json({
            "message":"client updated successfully",
            "data":clients
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// DELETE CLIENT DATA 
export const deleteClientContoller = async(request,response)=>{
    try {
        const clientId = request.params.id
        const clients = await deleteClientService(clientId)
        return response.status(200).json({
            "message":"client deleted successfully",
            "data":clients
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}