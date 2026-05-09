import {addAdminController} from "./admin.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/admin/add
API.post("/add",addAdminController)
export default API