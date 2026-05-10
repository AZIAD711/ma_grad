import {addClientController,getAllClientsContoller} from "./client.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/client/add
API.post("/add",addClientController)
// http://localhost:3000/client/
API.get("/",getAllClientsContoller)
export default API