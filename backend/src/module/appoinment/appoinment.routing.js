import {addAppoinmentController,getAllAppoinmentContoller} from "./appoinment.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/appoinment/add
API.post("/add",addAppoinmentController)
// http://localhost:3000/appoinment/
API.get("/",getAllAppoinmentContoller)
export default API