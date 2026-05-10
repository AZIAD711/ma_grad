import { Order } from "../../model/order.model.js"
// ADD A NEW ORDER 
export const addOrderService = async(data)=>{
    return await Order.create(data)
}
// GET ALL ORDERS 
export const getAllOrdersService = async()=>{
    return await Order.findAll()
}
// GET ORDER BY ID 
export const getOrderByIdService = async(id)=>{
    return await Order.findByPk(id)
}
// UPDATE ORDER DATA 
export const updateOrderService = async(data,id)=>{
    return await Order.update(data,{
        where:{
            orderId:id
        }
    })
}