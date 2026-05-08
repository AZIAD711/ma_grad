import {addFeedbackController,getAllFeedbacksContoller,getFeedbackByIdContoller,updateFeedbackContoller,deleteFeedbackContoller} from "./feedback.contoller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/feedback/add
API.post("/add",addFeedbackController)
// http://localhost:3000/feedback/
API.get("/",getAllFeedbacksContoller)
// http://localhost:3000/feedback/:id
API.get("/:id",getFeedbackByIdContoller)
// http://localhost:3000/feedback/update/:id
API.put("/update/:id",updateFeedbackContoller)
// http://localhost:3000/feedback/delete/:id
API.delete("/delete/:id",deleteFeedbackContoller)
export default API