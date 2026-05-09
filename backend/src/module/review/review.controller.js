import {addReviewService} from "./review.service.js"
// ADD NEW USER 
export const addReviewController = async(request,response)=>{
    try {
        const reviewBody = request.body
        const reviews = await addReviewService(reviewBody)
        return response.status(201).json({
            "message":"review added successfully",
            "data":reviews
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}