import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const SubcriptionPlan = database.define("subcription_plan",{
    // SUBCRIPTION PLAN ID 
    subriptionPlanId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"subription_plan_id"
    },
    // ANNUAL PRICE 
    annualPrice : {
        type : DataTypes.DECIMAL(10,2),
        field : "annual_price"
    },
    // MONTHLY PRICE 
    monthlyPrice : {
        type : DataTypes.DECIMAL(10,2),
        field : "monthly_price"
    },

},
{
    timestamps:true,
    createdAt : "created_at",
    updatedAt : "updated_at"
}
)