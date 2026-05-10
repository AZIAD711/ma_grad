import {addWorkerCountryMarketController} from "./worker-country-market.controller.js"
import express from "express"
const API = express.Router()
API.use(express.json())
// http://localhost:3000/worker/country/market/add
API.post("/add",addWorkerCountryMarketController)
export default API