import {addOrderController, getAllOrdersContoller,getOrderByIdContoller,updateOrderContoller} from "./order.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/order/add
API.post("/add",addOrderController)
// http://localhost:3000/order/
API.get("/",getAllOrdersContoller)
// http://localhost:3000/order/:id
API.get("/:id",getOrderByIdContoller)
// http://localhost:3000/order/update/:id
API.put("/update/:id",updateOrderContoller)
export default API