import {addUserController,getAllUsersContoller,getUserByIdContoller,updateUserContoller,deleteUserContoller,loignUserController} from "./auth.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/user/add
API.post("/add",addUserController)
// http://localhost:3000/user
API.get("/",getAllUsersContoller)
// http://localhost:3000/user/:id
API.get("/:id",getUserByIdContoller)
// http://localhost:3000/user/update/:id
API.put("/update/:id",updateUserContoller)
// http://localhost:3000/user/delete/:id
API.delete("/delete/:id",deleteUserContoller)
// http://localhost:3000/user/login
API.post("/login",loignUserController)
export default API