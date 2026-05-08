import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const Worker = database.define("worker",{
    // WORKER ID 
    workerId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"worker_id"
    },
    // NATIOLITY ID 
    natiolityId : {
    type : DataTypes.STRING(16),
    field : "natiolity_id"
    },
    // LOCATION 
    location : {
        type : DataTypes.TEXT,
    },
    // JOB TITLE 
    jobTitle : {
        type : DataTypes.ENUM(
      'Painter',
      'Air Conditioning Technician',
      'Electrician',
      'Plumber',
      'Carpenter'
    ),
        field : "job_title"
    }
},
{
    timestamps:true,
    createdAt : "created_at",
    updatedAt : "updated_at"
}
)