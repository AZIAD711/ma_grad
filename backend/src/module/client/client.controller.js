import {addClientService} from "./client.service.js"
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