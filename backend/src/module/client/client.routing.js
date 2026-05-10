import {addClientController} from "./client.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/client/add
API.post("/add",addClientController)

export default API