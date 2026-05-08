import app from "./app.js"
import { databaseConnection as database } from "../backend/src/database/connection.js"

const startServer = async () => {
    try { 
        await database.sync({
            // force: true
        })
        const port = 3000
        app.listen(port, () => {
            console.log(`✅ SERVER IS RUNNING ON http://localhost:${port}`)
        })
    } catch (error) {
        console.log(`❌ ERROR IN SERVER : ${error}`)

    }
}
startServer()