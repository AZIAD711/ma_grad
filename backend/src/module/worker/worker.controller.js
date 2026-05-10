import {addWorkerService} from "./worker.service.js"
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