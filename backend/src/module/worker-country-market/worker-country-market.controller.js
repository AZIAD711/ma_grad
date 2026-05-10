import {addWorkerCountryMarketService,getAllWorkerCountryMarketService} from "./worker-country-market.service.js"
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