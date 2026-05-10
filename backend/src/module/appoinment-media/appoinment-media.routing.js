import {addUserController} from "./appoinment-media.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/appoinment/media/add
API.post("/add",addUserController)
export default API