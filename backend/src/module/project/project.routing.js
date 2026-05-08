import {addProjectController,getAllProjectsContoller} from "./project.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/project/add
API.post("/add",addProjectController)
// http://localhost:3000/project/
API.post("/",getAllProjectsContoller)
export default API