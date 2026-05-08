import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const ChatUsers = database.define("chat_users",{
    // CHAT USER ID 
    chatUserId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"chat_user_id"
    },
    // CHAT USER ID 
    chatId : {
        type : DataTypes.INTEGER,
        field:"chat_id"
    },
    //  USER ID 
    userId : {
        type : DataTypes.INTEGER,
        field:"user_id"
    },
},
{
    timestamps:true,
    createdAt : "created_at",
    updatedAt : "updated_at"
}
)