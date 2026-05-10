import { Client } from "../../model/client.model.js"

// ADD A NEW CLIENT 
export const addClientService = async(data)=>{
    return await Client.create(data)
}
// GET ALL CLIENTS 
export const getAllClientsService = async()=>{
    return await Client.findAll()
}
// GET CLIENT BY ID 
export const getClientByIdService = async(id)=>{
    return await Client.findByPk(id)
}