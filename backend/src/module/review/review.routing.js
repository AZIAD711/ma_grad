import {addReviewController,getAllReviewsContoller,getReviewByIdContoller,deleteReviewContoller,updateReviewContoller} from "./review.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/review/add
API.post("/add",addReviewController)
// http://localhost:3000/review/
API.get("/",getAllReviewsContoller)
// http://localhost:3000/review/:id
API.get("/:id",getReviewByIdContoller)
// http://localhost:3000/review/update/:id
API.put("/update/:id",updateReviewContoller)
// http://localhost:3000/review/delete/:id
API.delete("/delete/:id",deleteReviewContoller)
export default API