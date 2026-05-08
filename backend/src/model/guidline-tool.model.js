import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const GuidelineTools = database.define("guideline_tools",{
    // GIUDELINE ID 
    guidelineId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"guideline_id"
    },
    // TOOLS
    tool : {
        type : DataTypes.STRING(100),
    },
},
{
    timestamps:true,
    createdAt : "created_at",
    updatedAt : "updated_at"
}
)