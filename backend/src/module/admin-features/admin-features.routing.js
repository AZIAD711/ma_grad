import {addAdminFeaturesController,getAllAdminFeaturesContoller,getAdminFeaturesByIdContoller} from "./admin-features.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/admin/feature/add
API.post("/add",addAdminFeaturesController)
// http://localhost:3000/admin/feature
API.get("/",getAllAdminFeaturesContoller)
// http://localhost:3000/admin/feature/:id
API.get("/:id",getAdminFeaturesByIdContoller)
export default API