import {addProjectController,getAllProjectsContoller,getProjectByIdContoller,updateProjectContoller} from "./project.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/project/add
API.post("/add",addProjectController)
// http://localhost:3000/project/
API.get("/",getAllProjectsContoller)
// http://localhost:3000/project/:id
API.get("/:id",getProjectByIdContoller)
// http://localhost:3000/project/update/:id
API.put("/update/:id",updateProjectContoller)
export default API