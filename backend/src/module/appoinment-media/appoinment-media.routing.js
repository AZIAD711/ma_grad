import {addUserController,getAllAppoinmentMediaContoller,getAppoinmentMediaByIdContoller} from "./appoinment-media.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/appoinment/media/add
API.post("/add",addUserController)
// http://localhost:3000/appoinment/media/
API.get("/",getAllAppoinmentMediaContoller)
// http://localhost:3000/appoinment/media/:id
API.get("/:id",getAppoinmentMediaByIdContoller)
export default API