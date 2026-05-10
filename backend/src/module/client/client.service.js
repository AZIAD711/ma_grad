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
// UPDATE CLIENT DATA 
export const updateClientService = async(data,id)=>{
    return await Client.update(data,{
        where:{
            clientId:id
        }
    })
}
// DELETE CLIENT DATA 
export const deleteClientService = async(id)=>{
    return await Client.destroy({
        where:{
            clientId:id
        }
    })
}