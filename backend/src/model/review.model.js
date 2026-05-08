import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const Review = database.define("review",{
    // REVIEW ID 
    reviewId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"review_id"
    },
    // TOTAL OF FOLLOWER 
    totalOfFollower : {
        type : DataTypes.INTEGER,
        field : "total_of_follower"
    },
    // TOTAL OF VIEW 
    totalOfView : {
        type : DataTypes.INTEGER,
        field : "total_of_view"
    },
    // TOTAL OF LIKE 
    totalOfLike : {
        type : DataTypes.INTEGER,
        field : "total_of_like"
    },
    // COMMENT 
    comment : {
        type : DataTypes.TEXT,
    }

},
{
    timestamps:true,
    createdAt : "created_at",
    updatedAt : "updated_at"
}
)