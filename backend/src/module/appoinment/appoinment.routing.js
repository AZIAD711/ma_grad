import {addAppoinmentController,getAllAppoinmentContoller,getAppoinmentByIdContoller} from "./appoinment.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/appoinment/add
API.post("/add",addAppoinmentController)
// http://localhost:3000/appoinment/
API.get("/",getAllAppoinmentContoller)
// http://localhost:3000/appoinment/:id
API.get("/:id",getAppoinmentByIdContoller)
export default API