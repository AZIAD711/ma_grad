import {addOrderController} from "./notification.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/notification/add
API.post("/add",addOrderController)
export default API