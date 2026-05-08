import {addFeedbackService} from "./feedback.service.js"
// ADD NEW FEEDBACK 
export const addFeedbackController = async(request,response)=>{
    try {
        const feedbackBody = request.body
        const newFeedback = await addFeedbackService(feedbackBody)
        return response.status(201).json({
            "message":"feedback added successfully",
            "data":newFeedback
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}