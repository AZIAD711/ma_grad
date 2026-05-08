import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const Feedback = database.define("feedback",{
    // FEEDBACK ID 
    feedbackId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"feedback_id"
    },
    // RATE
    rate : {
        type : DataTypes.INTEGER,
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