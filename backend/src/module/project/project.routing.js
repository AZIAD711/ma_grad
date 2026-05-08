import {addProjectController} from "./project.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/project/add
API.post("/add",addProjectController)
export default API