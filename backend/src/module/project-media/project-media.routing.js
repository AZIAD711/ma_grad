import {addProjectMediaController,getAllProjectMediaContoller} from "./project-media.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/project/media/add
API.post("/add",addProjectMediaController)
// http://localhost:3000/project/media/
API.get("/",getAllProjectMediaContoller)
export default API