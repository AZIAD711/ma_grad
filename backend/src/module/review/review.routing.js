import {addReviewController} from "./review.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/review/add
API.post("/add",addReviewController)
export default API