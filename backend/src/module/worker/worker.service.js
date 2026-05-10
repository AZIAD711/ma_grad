import { Worker } from "../../model/worker.model.js"
// ADD A NEW WORKER 
export const addWorkerService = async(data)=>{
    return await Worker.create(data)
}