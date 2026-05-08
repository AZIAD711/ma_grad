import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const Appoinment = database.define("appointment",{
    // APPOINMENT ID 
    appoinment : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"appointment_id"
    },
    // appoinment_type 
    appoinmentType : {
        type : DataTypes.ENUM("on-site","online"),
        field:"appoinment_type"
    
    },
    // PRICE 
    price : {
        type : DataTypes.DECIMAL(10,2),
    },
    // START TIME  
    startTime :{
        type : DataTypes.TIME,
        field:"start_time"
    },
    // END TIME 
    endTime : {
        type : DataTypes.TIME,
        field:"end_time"
    },
    // STATUS 
    status : {
        type : DataTypes.ENUM("pending","accepted","rejected"),
        defaultValue:"pending"
    },
    // LOCATION 
    location : {
        type : DataTypes.TEXT,
    },
    // DEADLINE
    deadline : {
        type : DataTypes.DATE,
    },
    // MEETING LINK
    meetingLink : {
        type : DataTypes.TEXT,
        field : "meeting_link"
    },
    // PROBLEM DESCRIPTION 
    problemDescription : {
        type : DataTypes.TEXT,
        field : "problem_description"
    }
},
{
    timestamps:true,
    createdAt : "created_at",
    updatedAt : "updated_at"
}
)