import {addOrderController,getAllNotificationsContoller,getNotificationByIdContoller,updateNotificationContoller,deleteNotificationContoller} from "./notification.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/notification/add
API.post("/add",addOrderController)
// http://localhost:3000/notification/
API.get("/",getAllNotificationsContoller)
// http://localhost:3000/notification/:id
API.get("/:id",getNotificationByIdContoller)
// http://localhost:3000/notification/update/:id
API.put("/update/:id",updateNotificationContoller)
// http://localhost:3000/notification/delete/:id
API.delete("/delete/:id",deleteNotificationContoller)
export default API