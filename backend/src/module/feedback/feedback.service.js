import { Feedback } from "../../model/feedback.model.js"
// ADD A NEW FEEDBACK
export const addFeedbackService = async(data)=>{
    return await Feedback.create(data)
}
// GET ALL FEEDBACK 
export const getAllFeedbacksService = async()=>{
    return await Feedback.findAll()
}
// GET FEEDBACK BY ID 
export const getFeedbackByIdService = async(id)=>{
    return await Feedback.findByPk(id)
}
