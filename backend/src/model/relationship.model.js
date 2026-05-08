// IMPORT ALL MODEL REQUIRED 
import { User } from "../model/user.model.js"
import { Client } from "../model/client.model.js"
import { Worker } from "../model/worker.model.js"
import { Admin } from "../model/admin.model.js"
import { Order } from "../model/order.model.js"
import { Feedback } from "../model/feedback.model.js"
import { Notification } from "../model/notification.model.js"
import { Appoinment } from "../model/appoinment.model.js"
import { Chat } from "../model/chat.model.js"
import { ChatUsers } from "../model/chat-users.model.js"
import { AppoinmentMedia } from "../model/appoinment-media.model.js"
import { AdminFeatures } from "../model/admin.features.model.js"
import { Project } from "../model/project.model.js"
import { ProjectMedia } from "../model/project-media.model.js"
import { SubcriptionPlan } from "../model/subription-plan.model.js"
import { SubcriptionPlanFeatures } from "../model/subription-plan-features.model.js"
import { WorkerCountryMarket } from "../model/worker-country-market.model.js"
import { Guideline } from "../model/guidline.model.js"
import { GuidlineMedia } from "../model/guidline-media.model.js"
import { GuidelineTools } from "../model/guidline-tool.model.js"
import { Message } from "../model/message.model.js"
import { ContactUs } from "../model/contact-us.model.js"
import { Review } from "../model/review.model.js"
export const defineRelationship = () => {
    // USER => CLIENT 
    User.hasOne(Client, {
        foreignKey: "userId",
        onDelete: "CASCADE",
        onUpdate: "CASCADE"
    })
    Client.belongsTo(User, {
        foreignKey: "userId",
    })
    // USER => WORKER 
    User.hasOne(Worker, {
        foreignKey: "userId",
        onDelete: "CASCADE",
        onUpdate: "CASCADE"
    })
    Worker.belongsTo(User, {
        foreignKey: "userId",
    })
    // USER => ADMIN 
    User.hasOne(Admin, {
        foreignKey: "userId",
        onDelete: "CASCADE",
        onUpdate: "CASCADE"
    })
    Admin.belongsTo(User, {
        foreignKey: "userId",
    })
    // USER => NOTIFICATION 
    User.hasMany(Notification, {
        foreignKey: "userId",
        onDelete: "CASCADE",
        onUpdate: "CASCADE"
    })
    Notification.belongsTo(User, {
        foreignKey: "userId",
    })
    // USER => MESSAGE 
    User.hasMany(Message, {
        foreignKey: "userId",
        onDelete: "CASCADE",
        onUpdate: "CASCADE"
    })
    Message.belongsTo(User, {
        foreignKey: "userId",
    })
    // MESSAGE => CHAT 
    Chat.hasMany(Message, {
        foreignKey: "chatId",
        onDelete: "CASCADE",
        onUpdate: "CASCADE"
    })
    Message.belongsTo(Chat, {
        foreignKey: "chatId",
    })
    // CHAT USERS => USER => MESSAGE 
    User.belongsToMany(Chat, {
        through: ChatUsers,
        foreignKey: "userId",
    })
    Chat.belongsToMany(User, {
        through: ChatUsers,
        foreignKey: "chatId",
    })
    // CLIENT => FEEDBACK 
    Client.hasMany(Feedback, {
        foreignKey: "clientId",
        onDelete: "CASCADE",
        onUpdate: "CASCADE"
    })
    Feedback.belongsTo(Client, {
        foreignKey: "clientId",
    })
    // CLIENT => CONTACT US
    Client.hasMany(ContactUs, {
        foreignKey: "clientId",
        onDelete: "CASCADE",
        onUpdate: "CASCADE"
    })
    ContactUs.belongsTo(Client, {
        foreignKey: "clientId",
    })
    // CLIENT => APPOINMENT 
    Client.hasMany(Appoinment, {
        foreignKey: "clientId",
        onDelete: "CASCADE",
        onUpdate: "CASCADE"
    })
    Appoinment.belongsTo(Client, {
        foreignKey: "clientId",
    })
    // CLIENT => ORDER 
    Client(Order, {
        foreignKey: "clientId",
        onDelete: "CASCADE",
        onUpdate: "CASCADE"
    })
    // CLIENT => SUBCRIPTION PLAN 
    Client.hasMany(SubcriptionPlan, {
        foreignKey: "clientId",
        onDelete: "CASCADE",
        onUpdate: "CASCADE"
    })
    SubcriptionPlan.belongsTo(Client, {
        foreignKey: "clientId",
    })
    Order.belongsTo(Client, {
        foreignKey: "clientId",
    })
    // WORKER => PROJECT 
    Worker.hasMany(Project, {
        foreignKey: "workerId",
        onDelete: "CASCADE",
        onUpdate: "CASCADE"
    })
    Project.belongsTo(Worker, {
    foreignKey: "workerId",
    })
    // WORKER => WORKER COUNTRY MARKET
    Worker.hasMany(WorkerCountryMarket, {
        foreignKey: "workerId",
        onDelete: "CASCADE",
        onUpdate: "CASCADE"
    })
    WorkerCountryMarket.belongsTo(Worker, {
        foreignKey: "workerId",
    })
    // WORKER => APPOINMENT 
    Worker.hasMany(Appoinment, {
        foreignKey: "workerId",
        onDelete: "CASCADE",
        onUpdate: "CASCADE"
    })
    Appoinment.belongsTo(Worker, {
        foreignKey: "workerId",
    })
    // WORKER => REVIEW 
    Worker.hasMany(Review, {
        foreignKey: "workerId",
        onDelete: "CASCADE",
        onUpdate: "CASCADE"
    })
    Review.belongsTo(Worker, {
        foreignKey: "workerId",
    })
    // APPINMENT => APPOINMENT MEDIA
    Appoinment.hasMany(AppoinmentMedia, {
        foreignKey: "appoinmentId",
        onDelete: "CASCADE",
        onUpdate: "CASCADE"
    })
    AppoinmentMedia.belongsTo(Appoinment, {
        foreignKey: "appoinmentId",
    })
    // PROJECT => PROJECT MEDIA
    Project.hasMany(ProjectMedia, {
        foreignKey: "projectId",
        onDelete: "CASCADE",
        onUpdate: "CASCADE"
    })
    ProjectMedia.belongsTo(Project, {
        foreignKey: "projectId",
    })
    // GUIDLINE => GUIDLINE MEDIA
    Guidline.hasMany(GuidlineMedia, {
        foreignKey: "guidlineId",
        onDelete: "CASCADE",
        onUpdate: "CASCADE"
    })
    GuidlineMedia.belongsTo(Guidline, {
        foreignKey: "guidlineId",
    })
    // GUIDLINE => GUIDLINE TOOLS
    Guidline.hasOne(GuidelineTools, {
        foreignKey: "guidlineId",
        onDelete: "CASCADE",
        onUpdate: "CASCADE"
    })
    GuidelineTools.belongsTo(Guidline, {
        foreignKey: "guidlineId",
    })
    // SUBCRIPTION PLAN => SUBCRIPTION PLAN FEATURES
    SubcriptionPlan.hasOne(SubcriptionPlanFeatures, {
        foreignKey: "subriptionPlanId",
        onDelete: "CASCADE",
        onUpdate: "CASCADE"
    })
    SubcriptionPlanFeatures.belongsTo(SubcriptionPlan, {
        foreignKey: "subriptionPlanId",
    })
    // ADMIN => ADMIN FEATURES 
    Admin.hasOne(AdminFeatures, {
        foreignKey: "adminId",
        onDelete: "CASCADE",
        onUpdate: "CASCADE"
    })
    AdminFeatures.belongsTo(Admin, {
        foreignKey: "adminId",
    })
}
