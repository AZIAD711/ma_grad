import { Client } from "../../model/client.model.js"

// ADD A NEW CLIENT 
export const addClientService = async(data)=>{
    return await Client.create(data)
}