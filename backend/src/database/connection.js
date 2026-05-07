import { Sequelize } from "sequelize";

// CONNECTION DATABASE 
export const databaseConnection = new Sequelize("marwan_grad","root","",{
    host : "127.0.0.1",
    dialect:"mysql",
    port : 3308
})
// CHECK CONNECTION WITH DATABASE
export const checkConnctionOfDatabase = async()=>{
    try {
        await databaseConnection.authenticate()
        console.log("✅ DATABASE CONNECTED SUCCESSFULLY")
    } catch (error) {
        console.log(`❌ ERROR IN CONNECTION OF DATABASE : ${error}`)
    }
}
checkConnctionOfDatabase()