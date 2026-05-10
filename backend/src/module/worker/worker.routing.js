import {addWorkerController,getAllWorkersContoller,getWorkerByIdContoller} from "./worker.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/worker/add
API.post("/add",addWorkerController)
// http://localhost:3000/worker/
API.get("/",getAllWorkersContoller)
// http://localhost:3000/worker/:id
API.get("/:id",getWorkerByIdContoller)
export default API