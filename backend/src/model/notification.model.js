import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const Notification = database.define("notification",{
    // NOTIFICATION ID 
    notificationId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"notification_id"
    },
    // TITLE 
    name : {
        type : DataTypes.STRING(100),
    },
    // DESCRIPTION 
    description :{
        type : DataTypes.TEXT,
    },
    // PHOTO 
    photo : {
        type: DataTypes.TEXT
    },
},
{
    timestamps:true,
    createdAt : "created_at",
    updatedAt : "updated_at"
}
)