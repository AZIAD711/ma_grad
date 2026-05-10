import {addWorkerCountryMarketController,getAllWorkerCountryMarketContoller,getWorkerCountryMarketByIdContoller,updateWorkerCountryMarketContoller,deleteWorkerCountryMarketContoller} from "./worker-country-market.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/worker/country/market/add
API.post("/add",addWorkerCountryMarketController)
// http://localhost:3000/worker/country/market/
API.get("/",getAllWorkerCountryMarketContoller)
// http://localhost:3000/worker/country/market/:id
API.get("/:id",getWorkerCountryMarketByIdContoller)
// http://localhost:3000/worker/country/market/update/:id
API.put("/update/:id",updateWorkerCountryMarketContoller)
// http://localhost:3000/worker/country/market/delete/:id
API.delete("/delete/:id",deleteWorkerCountryMarketContoller)
export default API