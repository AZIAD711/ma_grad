import { Review } from "../../model/review.model.js"
// ADD A NEW REVIEW 
export const addReviewService = async(data)=>{
    return await Review.create(data)
}
// GET ALL REVIEWS 
export const getAllReviewsService = async()=>{
    return await Review.findAll()
}
// GET REVIEW BY ID 
export const getReviewByIdService = async(id)=>{
    return await Review.findByPk(id)
}