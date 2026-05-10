import { Order } from "../../model/order.model.js"
// ADD A NEW ORDER 
export const addOrderService = async(data)=>{
    return await Order.create(data)
}