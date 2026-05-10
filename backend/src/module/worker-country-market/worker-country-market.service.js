import { WorkerCountryMarket } from "../../model/worker-country-market.model.js"
// ADD A NEW WORKER COUNTRY MARKET
export const addWorkerCountryMarketService = async(data)=>{
    return await WorkerCountryMarket.create(data)
}
// GET ALL WORKERS COUNTRY MARKET 
export const getAllWorkerCountryMarketService = async()=>{
    return await WorkerCountryMarket.findAll()
}
// GET WORKER COUNTRY MARKET BY ID 
export const getWorkerCountryMarketByIdService = async(id)=>{
    return await WorkerCountryMarket.findByPk(id)
}
// UPDATE WORKER COUNTRY MARKET DATA 
export const updateWorkerCountryMarketService = async(data,id)=>{
    return await WorkerCountryMarket.update(data,{
        where:{
            workerId:id
        }
    })
}
// DELETE WORKER COUNTRY MARKET DATA 
export const deleteWorkerCountryMarketService = async(id)=>{
    return await WorkerCountryMarket.destroy({
        where:{
            workerId:id
        }
    })
}