import {addWorkerService,getAllWorkersService,getWorkerByIdService,updateWorkerService} from "./worker.service.js"
// ADD NEW USER 
export const addWorkerController = async(request,response)=>{
    try {
        const workerBody = request.body
        const newWorker = await addWorkerService(workerBody)
        return response.status(201).json({
            "message":"wroker added successfully",
            "data":newWorker
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// GET ALL WORKERS 
export const getAllWorkersContoller = async(request,response)=>{
    try {
        const workers = await getAllWorkersService()
        return response.status(200).json({
            "message":"workers fetched successfully",
            "data":workers
        })
    } catch (error) {
                console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// GET WORKER BY ID 
export const getWorkerByIdContoller = async(request,response)=>{
    try {
        const workerId = request.params.id
        const workers = await getWorkerByIdService(workerId)
        return response.status(200).json({
            "message":"worker fetched successfully",
            "data":workers
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// UPDATE WORKER DATA 
export const updateWorkerContoller = async(request,response)=>{
    try {
        const workerId = request.params.id
        const workerBody = request.body
        const workers = await updateWorkerService(workerBody,workerId)
        return response.status(200).json({
            "message":"worker updated successfully",
            "data":workers
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}