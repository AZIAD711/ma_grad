import {addProjectMediaController} from "./project-media.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/project/media/add
API.post("/add",addProjectMediaController)
export default API