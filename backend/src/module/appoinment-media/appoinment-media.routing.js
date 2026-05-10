import {addUserController,getAllAppoinmentMediaContoller,getAppoinmentMediaByIdContoller,updateAppoinmentMediaContoller} from "./appoinment-media.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/appoinment/media/add
API.post("/add",addUserController)
// http://localhost:3000/appoinment/media/
API.get("/",getAllAppoinmentMediaContoller)
// http://localhost:3000/appoinment/media/:id
API.get("/:id",getAppoinmentMediaByIdContoller)
// http://localhost:3000/appoinment/media/update/:id
API.put("/update/:id",updateAppoinmentMediaContoller)
export default API