import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const Client = database.define("client",{
    // CLIENT ID 
    clientId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"client_id"
    },
    // GENDER 
    gender : {
        type : DataTypes.ENUM("male","female"),
    allowNull:false
    },
    // SALARY 
    salary : {
        type : DataTypes.DECIMAL(10,2),
        allowNull: false
    },
    // INCOME LEVEL  
    incomeLevel :{
        type : DataTypes.ENUM("high","medium","low","not provided"),
        defaultValue:"not provided",
        field : "income_level"
    },
},
{
    timestamps:true,
    createdAt : "created_at",
    updatedAt : "updated_at"
}
)