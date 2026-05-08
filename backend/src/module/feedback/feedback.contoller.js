import {addFeedbackService,getAllFeedbacksService,getFeedbackByIdService,updateFeedbackService,deleteFeedbackService} from "./feedback.service.js"
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
// GET ALL FEEDBACKS 
export const getAllFeedbacksContoller = async(request,response)=>{
    try {
        const feedback = await getAllFeedbacksService()
        return response.status(200).json({
            "message":"feedbacks fetched successfully",
            "data":feedback
        })
    } catch (error) {
                console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// GET FEEDBACK BY ID 
export const getFeedbackByIdContoller = async(request,response)=>{
    try {
        const feedbackId = request.params.id
        const feedback = await getFeedbackByIdService(feedbackId)
        return response.status(200).json({
            "message":"feedback fetched successfully",
            "data":feedback
        })
    } catch (error) {
                console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// UPDATE FEEDBACK DATA 
export const updateFeedbackContoller = async(request,response)=>{
    try {
        const feedbackId = request.params.id
        const feedbackBody = request.body
        const feedbacks = await updateFeedbackService(feedbackBody,feedbackId)
        return response.status(200).json({
            "message":"feedbacks updated successfully",
            "data":feedbacks
        })
    } catch (error) {
                        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// DELETE FEEDBACK DATA 
export const deleteFeedbackContoller = async(request,response)=>{
    try {
        const feedbackId = request.params.id
        const feedbacks = await deleteFeedbackService(feedbackId)
        return response.status(200).json({
            "message":"feedback deleted successfully",
            "data":feedbacks
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}