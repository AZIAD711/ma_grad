import {addWorkerController} from "./worker.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/worker/add
API.post("/add",addWorkerController)
export default API