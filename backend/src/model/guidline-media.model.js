import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const GuidlineMedia = database.define("guidline_media",{
    // GUIDLINE MEDIA ID 
    guidlineMediaId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"guidline_media_id"
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