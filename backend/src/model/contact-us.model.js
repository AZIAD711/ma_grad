import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const ContactUs = database.define("contact_us",{
    // CONTACT US ID 
    contactUsId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"contact_us_id"
    },
    // MESSAGE
    message : {
        type : DataTypes.TEXT,
    },
    // PHONE NUMBER 
    phoneNumber : {
        type : DataTypes.STRING(11),
        field : "phone_number"
    },
    // EMAIL 
    email : {
        type : DataTypes.STRING(100),
    },

},
{
    timestamps:true,
    createdAt : "created_at",
    updatedAt : "updated_at"
}
)