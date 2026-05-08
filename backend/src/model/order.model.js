import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const Order = database.define("order",{
    // ORDER ID 
    orderId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"order_id"
    },
    // FEE 
    fee : {
        type : DataTypes.DECIMAL(10,2),
    },
    // PRICE 
    price : {
        type : DataTypes.DECIMAL(10,2),
    },
    // PAYMENT METHOD  
    paymentMethod :{
        type : DataTypes.ENUM("cash","card"),
        field:"payment_method"
    },
    // STATUS 
    status : {
        type : DataTypes.ENUM("pending","accepted","rejected"),
        defaultValue:"pending"
    }
},
{
    timestamps:true,
    createdAt : "created_at",
    updatedAt : "updated_at"
}
)