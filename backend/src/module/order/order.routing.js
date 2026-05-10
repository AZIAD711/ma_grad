import {addOrderController, getAllOrdersContoller} from "./order.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/order/add
API.post("/add",addOrderController)
// http://localhost:3000/order/
API.get("/",getAllOrdersContoller)
export default API