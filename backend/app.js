import express from "express"
import userRouter from "./src/module/user/user.routing.js"
import projectRouter from "./src/module/project/project.routing.js"
import feedbackRouter from "./src/module/feedback/feedback.routing.js"
import adminRouter from './src/module/admin/admin.routing.js'
import adminFeaturesRouting from "./src/module/admin-features/admin-features.routing.js"
import reviewRouting from "./src/module/review/review.routing.js"
import projectMediaRouting from "./src/module/project-media/project-media.routing.js"
import appoinmentRouting from  "./src/module/appoinment/appoinment.routing.js"
import appoinmentMediaRouting from "./src/module/appoinment-media/appoinment-media.routing.js"
import clientRouting from "./src/module/client/client.routing.js"
import workerRouting from "./src/module/worker/worker.routing.js"
 const app = express()
app.use(express.json())
// USER MODULE
app.use("/user",userRouter)
// CLIENT MODULE 
app.use("/client",clientRouting)
// WORKER MODULE 
app.use("/worker",workerRouting)
// ADMIN MODULE 
app.use("/admin",adminRouter)
// ADMIN FEATURES MODULE 
app.use("/admin/feature",adminFeaturesRouting)
// PROJECT MODULE 
app.use("/project",projectRouter)
// PROJECT MEDIA MODULE 
app.use("/project/media",projectMediaRouting)
// FEEDBACK MODULE 
app.use("/feedback",feedbackRouter)
// REVIEW MODULE 
app.use("/review",reviewRouting)
// APPOINMENT MODULE 
app.use("/appoinment",appoinmentRouting)
// APPOINMENT MEDIA  MODULE 
app.use("/appoinment/media",appoinmentMediaRouting)
export default app