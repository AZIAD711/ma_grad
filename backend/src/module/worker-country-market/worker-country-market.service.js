import { WorkerCountryMarket } from "../../model/worker-country-market.model.js"
// ADD A NEW WORKER COUNTRY MARKET
export const addWorkerCountryMarketService = async(data)=>{
    return await WorkerCountryMarket.create(data)
}