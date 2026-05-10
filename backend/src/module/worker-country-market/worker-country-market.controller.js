import {addWorkerCountryMarketService,getAllWorkerCountryMarketService,getWorkerCountryMarketByIdService,updateWorkerCountryMarketService,deleteWorkerCountryMarketService} from "./worker-country-market.service.js"
// ADD NEW WORKER COUNTRY MARKET 
export const addWorkerCountryMarketController = async(request,response)=>{
    try {
        const workerCountryMarketBody = request.body
        const newWorkerCountryMarket = await addWorkerCountryMarketService(workerCountryMarketBody)
        return response.status(201).json({
            "message":"worker country market added successfully",
            "data":newWorkerCountryMarket
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// GET ALL WORKERS COUNTRY MARKET
export const getAllWorkerCountryMarketContoller = async(request,response)=>{
    try {
        const workerCountryMarket = await getAllWorkerCountryMarketService()
        return response.status(200).json({
            "message":"workers country market fetched successfully",
            "data":workerCountryMarket
        })
    } catch (error) {
                console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// GET WORKER COUNTRY MARKET BY ID 
export const getWorkerCountryMarketByIdContoller = async(request,response)=>{
    try {
        const workerCountryMarketId = request.params.id
        const workerCountryMarket = await getWorkerCountryMarketByIdService(workerCountryMarketId)
        return response.status(200).json({
            "message":"worker contry market fetched successfully",
            "data":workerCountryMarket
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// UPDATE WORKER COUNTRY MARKET DATA 
export const updateWorkerCountryMarketContoller = async(request,response)=>{
    try {
        const workerCountryMarketId = request.params.id
        const workerCountryMarketBody = request.body
        const workerCountryMarket = await updateWorkerCountryMarketService(workerCountryMarketBody,workerCountryMarketId)
        return response.status(200).json({
            "message":"worker contry market updated successfully",
            "data":workerCountryMarket
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// DELETE WORKER COUNTYR MARKET DATA 
export const deleteWorkerCountryMarketContoller = async(request,response)=>{
    try {
        const workerCountryMarketId = request.params.id
        const workerCountryMarket = await deleteWorkerCountryMarketService(workerCountryMarketId)
        return response.status(200).json({
            "message":"worker deleted successfully",
            "data":workerCountryMarket
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}