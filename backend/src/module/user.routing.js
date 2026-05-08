import {addUserController,getAllUsersContoller} from "./user.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/user/add
API.post("/add",addUserController)
// http://localhost:3000/user
API.get("/",getAllUsersContoller)
export default API