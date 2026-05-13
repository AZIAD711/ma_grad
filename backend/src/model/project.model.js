import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
import { User } from "./user.model.js"
export const Project = database.define("project",{
    // PROJECT ID 
    projectId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"project_id"
    },
    // TITLE 
    name : {
        type : DataTypes.STRING(100),
    },
    // DESCRIPTION 
    description :{
        type : DataTypes.TEXT,
    },
},
{
    timestamps:true,
    createdAt : "created_at",
    updatedAt : "updated_at"
}
)