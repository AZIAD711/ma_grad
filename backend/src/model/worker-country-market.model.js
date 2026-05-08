import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const WorkerCountryMarket = database.define("worker_country_market",{
    // WORKER ID 
    workerId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"worker_id"
    },
    // COUNTRY MARKET
    countryMarket : {
    type : DataTypes.STRING(150),
    field : "country_market"
    },
},
{
    timestamps:true,
    createdAt : "created_at",
    updatedAt : "updated_at"
}
)