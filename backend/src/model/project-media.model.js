import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const ProjectMedia = database.define("project_media",{
    // PROJECT MEDIA ID 
    projectMediaId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"project_media_id"
    },
    // TYPE 
    type : {
        type : DataTypes.ENUM("image","video"),
    },
    // URL
    url :{
        type : DataTypes.TEXT,
    },
},
{
    timestamps:true,
    createdAt : "created_at",
    updatedAt : "updated_at"
}
)