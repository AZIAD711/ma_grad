import {addAdminFeaturesController} from "./admin-features.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/admin/feature/add
API.post("/add",addAdminFeaturesController)
export default API