import {addAdminController,getAllAdminsContoller,getAdminByIdContoller} from "./admin.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/admin/add
API.post("/add",addAdminController)
// http://localhost:3000/admin
API.get("/",getAllAdminsContoller)
// http://localhost:3000/admin?:id
API.get("/:id",getAdminByIdContoller)
export default API