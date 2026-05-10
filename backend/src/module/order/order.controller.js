import {addOrderService} from "./order.service.js"
// ADD NEW ORDER 
export const addOrderController = async(request,response)=>{
    try {
        const orderBody = request.body
        const orders = await addOrderService(orderBody)
        return response.status(201).json({
            "message":"order added successfully",
            "data":orders
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}