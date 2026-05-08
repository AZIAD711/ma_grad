import { DataTypes } from "sequelize"
import {databaseConnection as database} from "../database/connection.js"
export const AdminFeatures = database.define("admin_features",{
    // ADMIN ID 
    adminId : {
        type : DataTypes.INTEGER,
        primaryKey : true,
        autoIncrement : true,
        field:"admin_id"
    },
    // FEATURES 
    feature : {
        type : DataTypes.STRING(100),
    },
},
{
    timestamps:true,
    createdAt : "created_at",
    updatedAt : "updated_at"
}
)