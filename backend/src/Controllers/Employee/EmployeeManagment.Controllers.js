import { STATUS_CODES } from "../../../constant.js";
import { taskAssignmentValidateMethod } from "../../Models/TaskAssignment.Model.js";
import { employeeAssignTaskReadService } from "../../Services/Employee/Employee.Services.js";
import { taskCheckOut, taskCompleteService } from "../../Services/Task.Services.js";
import { controllerHandler } from "../../Utils/ControllerHandler.js";
import { deleteImage } from "../../Utils/DeleteImageFromLocalServer.js";
import { SuccessResponse } from "../../Utils/Success.js";
import path from 'path';
export const employeeAssignedTaskRead = controllerHandler(async (req, res) => {
    const employeeId = req.user._id;

    const dataObject = {employeeId, ...req.body, ...req.query}
    const {tasks} = await employeeAssignTaskReadService(dataObject)

    res.status(STATUS_CODES.OK).json(new SuccessResponse(STATUS_CODES.OK, "Task read", tasks).toJson())
})



export const employeeCompletedTaskController = controllerHandler(async (req, res) => {
  const employeeId = req.user._id;
  let imageUrl;
  if (req.file?.path){
    imageUrl = req.file?.path
  }
  console.log(imageUrl)
  const dataObject = { ...req.body, employeeId, ...req.query, imageUrl };

  // const result = await taskCompleteService(dataObject);
  let taskAssignment; // declare it here
  try {
    const { method, taskAssignment: result} =  await taskCompleteService(dataObject);
    taskAssignment = result;
    
    if (method == taskAssignmentValidateMethod.AUTO){
      if (imageUrl){
        deleteImage(imageUrl) // delete image from local database
      }
      console.log("Task verified by system ")
      console.log(taskAssignment)
      return res.status(STATUS_CODES.OK).json(
        new SuccessResponse(
          STATUS_CODES.OK,
          'Task verified successfully by system',
          taskAssignment
        ).toJson()
      );
    }

  }catch (err){
    if (imageUrl){
      deleteImage(imageUrl) // delete image from local database
    }
    throw err
  }

  console.log(taskAssignment)
  return res.status(STATUS_CODES.OK).json(
    new SuccessResponse(
      STATUS_CODES.OK,
      'Task submitted for admin verification',
      taskAssignment
    ).toJson()
  );
});


export const employeeCompletedTaskCheckoutController = controllerHandler(async (req, res) => {
  const employeeId = req.user._id;
  const dataObject = { ...req.body, employeeId, ...req.query };

  await taskCheckOut(dataObject);

  return res.status(STATUS_CODES.SUCCESS_NO_RESPONSE).json(
    new SuccessResponse(
      STATUS_CODES.SUCCESS_NO_RESPONSE,
      'Task CheckOut Successful'
    ).toJson()
  );
});

