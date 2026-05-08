import express from "express"
import userRouter from "./src/module/user/user.routing.js"
import projectRouter from "./src/module/project/project.routing.js"
 const app = express()
app.use(express.json())
// USER MODULE
app.use("/user",userRouter)
// PROJECT MODULE 
app.use("/project",projectRouter)
export default app