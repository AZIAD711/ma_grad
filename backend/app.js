import express from "express"
import userRouter from "./src/module/user.routing.js"
 const app = express()
app.use(express.json())
// USER MODULE
app.use("/user",userRouter)
export default app