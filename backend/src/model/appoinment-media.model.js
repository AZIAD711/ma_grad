import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const AppoinmentMedia = database.define("appointment_media",{
    // APPOINMENT MEDIA ID 
    appoinmentMediaId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"appointment_media_id"
    },
    // TYPE
    type : {
        type : DataTypes.ENUM("image","video"),
    },
    // URL
    url : {
        type : DataTypes.TEXT,
    },
},
{
    timestamps:true,
    createdAt : "created_at",
    updatedAt : "updated_at"
}
)