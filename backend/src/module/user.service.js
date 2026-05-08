import {defineRelationship} from "../model/relationship.model.js"
import { User } from "../model/user.model.js"
// ADD A NEW USER 
export const addUserService = async(data)=>{
    return await User.create(data)
}