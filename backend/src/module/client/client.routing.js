import {addClientController,getAllClientsContoller,getClientByIdContoller,updateClientContoller} from "./client.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/client/add
API.post("/add",addClientController)
// http://localhost:3000/client/
API.get("/",getAllClientsContoller)
// http://localhost:3000/client/:id
API.get("/:id",getClientByIdContoller)
// http://localhost:3000/client/update/:id
API.put("/update/:id",updateClientContoller)
export default API