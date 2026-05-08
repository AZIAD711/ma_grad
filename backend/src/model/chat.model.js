import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const Chat = database.define("chat",{
    // CHAT ID 
    chatId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"chat_id"
    },
},
{
    timestamps:true,
    createdAt : "created_at",
    updatedAt : "updated_at"
}
)