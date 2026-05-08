import {addFeedbackController,getAllFeedbacksContoller} from "./feedback.contoller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/feedback/add
API.post("/add",addFeedbackController)
// http://localhost:3000/feedback/
API.get("/",getAllFeedbacksContoller)
export default API