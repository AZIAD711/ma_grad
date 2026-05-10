import {addAppoinmentController,getAllAppoinmentContoller,getAppoinmentByIdContoller,updateAppoinmentContoller,deleteAppoinmentContoller} from "./appoinment.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/appoinment/add
API.post("/add",addAppoinmentController)
// http://localhost:3000/appoinment/
API.get("/",getAllAppoinmentContoller)
// http://localhost:3000/appoinment/:id
API.get("/:id",getAppoinmentByIdContoller)
// http://localhost:3000/appoinment/update/:id
API.put("/update/:id",updateAppoinmentContoller)
// http://localhost:3000/appoinment/delete/:id
API.delete("/delete/:id",deleteAppoinmentContoller)
export default API