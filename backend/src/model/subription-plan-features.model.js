import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const SubcriptionPlanFeatures = database.define("subcription_plan_features",{
    // SUBCRIPTION PLAN ID 
    subriptionPlanId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"subription_plan_id"
    },
    // FEATURES 
    feature : {
        type : DataTypes.STRING(200),
    },

},
{
    timestamps:true,
    createdAt : "created_at",
    updatedAt : "updated_at"
}
)