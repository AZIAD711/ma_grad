import { Worker } from "../../model/worker.model.js"
// ADD A NEW WORKER 
export const addWorkerService = async(data)=>{
    return await Worker.create(data)
}
// GET ALL WORKERS 
export const getAllWorkersService = async()=>{
    return await Worker.findAll()
}
// GET WORKER BY ID 
export const getWorkerByIdService = async(id)=>{
    return await Worker.findByPk(id)
}
// UPDATE WORKER DATA 
export const updateWorkerService = async(data,id)=>{
    return await Worker.update(data,{
        where:{
            workerId:id
        }
    })
}
