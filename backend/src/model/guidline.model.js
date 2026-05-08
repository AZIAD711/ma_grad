import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const Guideline = database.define("guideline",{
    // GIUDELINE ID 
    guidelineId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"guideline_id"
    },
    // DESCRIPTION
    description : {
        type : DataTypes.TEXT,
    },
},
{
    timestamps:true,
    createdAt : "created_at",
    updatedAt : "updated_at"
}
)