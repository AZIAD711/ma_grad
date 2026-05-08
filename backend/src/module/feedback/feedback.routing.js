import {addFeedbackController} from "./feedback.contoller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/feedback/add
API.post("/add",addFeedbackController)
export default API