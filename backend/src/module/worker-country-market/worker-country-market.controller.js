import {addWorkerCountryMarketService} from "./worker-country-market.service.js"
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