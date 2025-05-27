import { Router } from "express";
import { upload } from "../Middlewares/Multer.Middleware.js";
import { validateHandler } from "../Utils/ValidateHandler.js";
import { employeeJWTDecode } from "../Middlewares/EmployeeJwt.Middleware.js";
import { validateEmployeeAssignTaskReadRoute, validateEmployeeChangePasswordRoutes, validateEmployeeCompleteTaskRoute, validateEmployeeForgetPasswordRoutes, validateEmployeeGetRoutes, validateEmployeeImageUploadRoute, validateEmployeeLoginRoutes, validateEmployeeRegisterRoutes } from "../Utils/Validators/Employee.Validation.js";
import { employeeChangePasswordController, employeeForgotPasswordController, employeeImageUploadController, employeeLoginController, employeeLogoutController, employeeProfileGetController, employeeRegisterController } from "../Controllers/Employee/Employee.Controllers.js";
import { completedTask } from "../Controllers/Admin/Task.Controllers.js";
import { employeeAssignedTaskRead, employeeCompletedTaskController } from "../Controllers/Employee/EmployeeManagment.Controllers.js"
import { validateEmployeeRegisterRoutesForEmployee } from "../Utils/Validators/Employee/Employee.Validate.js";
const employeeRoutes = Router();

// ----------------------- Employee Auths Routes -----------------------
employeeRoutes.route("/auth/register")
  .post(upload.single('image'), validateEmployeeRegisterRoutesForEmployee, validateHandler, employeeRegisterController);

employeeRoutes.route("/auth/login")
  .post( (req,res,next)=>{
    console.log("Testing")
    next()
  },validateEmployeeLoginRoutes, employeeLoginController);

employeeRoutes.route('/auth/user/profile')
  .get(employeeJWTDecode, validateHandler, employeeProfileGetController);

employeeRoutes.route("/auth/forget-password")
  .post(validateEmployeeForgetPasswordRoutes, employeeForgotPasswordController);

employeeRoutes.route("/auth/logout")
  .post(employeeJWTDecode, employeeLogoutController);

employeeRoutes.route("/auth/change-password")
  .post(validateEmployeeChangePasswordRoutes, employeeJWTDecode, employeeChangePasswordController);

employeeRoutes.route("/upload-image")
  .post(
    (req,res,next)=>{
      console.log(req.body)
    console.log("Testing")
    next()
  },
    employeeJWTDecode, upload.single('image'), validateEmployeeImageUploadRoute, validateHandler, employeeImageUploadController)




// ----------------------- Employee Task Management Routes -----------------------
employeeRoutes.route("/task/get")
  .get(employeeJWTDecode, (req, res, next) => res.send("Employees Get"))

employeeRoutes.route("/task/assign-task-read")
  .get(employeeJWTDecode, validateEmployeeAssignTaskReadRoute, validateHandler, employeeAssignedTaskRead)


employeeRoutes.route("/task/completed")
  .post(
    employeeJWTDecode,
    upload.single('image'),
    (req,_,next)=> {
      console.log(req.body)
      req.body = {
        taskAssignmentId: req.body.taskAssignmentId,
        currentTime: req.body.currentTime,
        location: {
          type: req.body.location.type,
          coordinates: req.body.location.coordinates.map(Number),
          // coordinates: [66.977,30.1718],
          address: req.body.location.address
        }
      };
      console.log(req.body)
      next()
    },
    validateEmployeeCompleteTaskRoute,
    validateHandler,
    employeeCompletedTaskController
  );



export { employeeRoutes };
