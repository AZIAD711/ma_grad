import {addOrderController,getAllNotificationsContoller} from "./notification.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/notification/add
API.post("/add",addOrderController)
// http://localhost:3000/notification/
API.get("/",getAllNotificationsContoller)
export default API