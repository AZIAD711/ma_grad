import {addProjectMediaController,getAllProjectMediaContoller,getProjectMediaByIdContoller,updateProjectMediaContoller} from "./project-media.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/project/media/add
API.post("/add",addProjectMediaController)
// http://localhost:3000/project/media/
API.get("/",getAllProjectMediaContoller)
// http://localhost:3000/project/media/:id
API.get("/:id",getProjectMediaByIdContoller)
// http://localhost:3000/project/media/update/:id
API.put("/update/:id",updateProjectMediaContoller)
// http://localhost:3000/project/media/delete/:id
API.delete("/delete/:id",updateProjectMediaContoller)
export default API