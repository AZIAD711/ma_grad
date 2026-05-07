import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const User = database.define("user",{
    // USER ID 
    userId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"user_id"
    },
    // NAME 
    name : {
        type : DataTypes.STRING(100),
        allowNull: false
    },
    // EMAIL 
    email :{
        type : DataTypes.STRING(100),
    },
    // PASSWORD 
    password : {
        type: DataTypes.STRING(8)
    },
    // PHONE NUMBER
    phoneNumber : {
        type : DataTypes.STRING(11),
        field : "phone_number"
    },
    // ROLE 
    role : {
        type : DataTypes.ENUM("worker","client","admin"),
        defaultValue:"client"
    },
    // PHOTO
    photo:{
        type : DataTypes.TEXT
    }
},
{
    timestamps:true,
    createdAt : "created_at",
    updatedAt : "updated_at"
}
)