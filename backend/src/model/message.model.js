import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const Message = database.define("message",{
    // MESSAGE ID 
    messsageId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"message_id"
    },
    // MESSAGE TEXT 
    messageText : {
        type : DataTypes.TEXT,
        field : "message_text"
    },
    // TIMESTAMP 
    timestamp :{
        type : DataTypes.TIME,
    },
},
{
    timestamps:true,
    createdAt : "created_at",
    updatedAt : "updated_at"
}
)