import {addReviewController,getAllReviewsContoller,getReviewByIdContoller} from "./review.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/review/add
API.post("/add",addReviewController)
// http://localhost:3000/review/
API.get("/",getAllReviewsContoller)
// http://localhost:3000/review/:id
API.get("/:id",getReviewByIdContoller)
export default API