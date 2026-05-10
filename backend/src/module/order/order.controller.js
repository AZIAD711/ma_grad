import {addOrderService,getAllOrdersService,getOrderByIdService,updateOrderService,deleteOrderService} from "./order.service.js"
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
// GET ALL ORDERS 
export const getAllOrdersContoller = async(request,response)=>{
    try {
        const orders = await getAllOrdersService()
        return response.status(200).json({
            "message":"orders fetched successfully",
            "data":orders
        })
    } catch (error) {
                console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// GET ORDER BY ID 
export const getOrderByIdContoller = async(request,response)=>{
    try {
        const orderId = request.params.id
        const orders = await getOrderByIdService(orderId)
        return response.status(200).json({
            "message":"order fetched successfully",
            "data":orders
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// UPDATE ORDER DATA 
export const updateOrderContoller = async(request,response)=>{
    try {
        const orderId = request.params.id
        const orderBody = request.body
        const orders = await updateOrderService(orderBody,orderId)
        return response.status(200).json({
            "message":"order updated successfully",
            "data":orders
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// DELETE ORDER DATA 
export const deleteOrderContoller = async(request,response)=>{
    try {
        const orderId = request.params.id
        const orders = await deleteOrderService(orderId)
        return response.status(200).json({
            "message":"order deleted successfully",
            "data":orders
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}