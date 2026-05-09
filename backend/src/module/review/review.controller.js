import {addReviewService,getAllReviewsService,getReviewByIdService} from "./review.service.js"
// ADD NEW REVIEW 
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
// GET ALL REVIEWS 
export const getAllReviewsContoller = async(request,response)=>{
    try {
        const reviews = await getAllReviewsService()
        return response.status(200).json({
            "message":"reviews fetched successfully",
            "data":reviews
        })
    } catch (error) {
                console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}
// GET REVIEW BY ID 
export const getReviewByIdContoller = async(request,response)=>{
    try {
        const reviewId = request.params.id
        const reviews = await getReviewByIdService(reviewId)
        return response.status(200).json({
            "message":"review fetched successfully",
            "data":reviews
        })
    } catch (error) {
        console.log(`❌ ERROR IN CONTROLLER : ${error}`)
        return response.status(500).json({
            "errorMessage":"something went wrong"
        })
    }
}