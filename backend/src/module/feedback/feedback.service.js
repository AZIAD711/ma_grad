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
// UPDATE FEEDBACK DATA 
export const updateFeedbackService = async(data,id)=>{
    return await Feedback.update(data,{
        where:{
            feedbackId:id
        }
    })
}
