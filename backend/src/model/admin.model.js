import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const Admin = database.define("admin",{
    // ADMIN ID 
    adminId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"admin_id"
    },
    // AUTHORITY LEVEL  
    authorityLevel : {
        type : DataTypes.ENUM("high","medium","low"),
        field : "authority_level"
    
    },
},
{
    timestamps:true,
    createdAt : "created_at",
    updatedAt : "updated_at"
}
)