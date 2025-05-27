import { STATUS_CODES } from "../../../constant.js";
import { SuccessResponse } from "../../Utils/Success.js";
import { controllerHandler } from "../../Utils/ControllerHandler.js";
import {
  getAssignTaskServices,
  getTasksWithAssignments,
  taskAssignService,
  taskCompleteService,
  taskCreateServices,
  taskDeleteService,
  taskStatusChangeServices,
  taskUpdateService,
  taskVerifiedServices
} from "../../Services/Task.Services.js";


export const taskCreateController = controllerHandler(async (req, res) => {
  const adminId = req.user._id;
  const dataObject = { adminId, ...req.body };
  const {task} = await taskCreateServices(dataObject);

  return res.status(STATUS_CODES.CREATED)
    .json(new SuccessResponse(STATUS_CODES.CREATED, 'Task created successfully', { task }).toJson());
});


export const taskReadController = controllerHandler(async (req, res) => {
  const adminId = req.user._id;

  const dataObject = { ...req.query, adminId };

  const {tasks} = await getTasksWithAssignments(dataObject);
    return res.status(STATUS_CODES.OK)
      .json(new SuccessResponse(
        STATUS_CODES.OK,
        'Tasks fetched successfully',
        { tasks }
      ).toJson());
});

export const taskAssignGetController = controllerHandler(async (req, res) => {
  const adminId = req.user._id;

  const dataObject = { ...req.query, adminId };

  const {assignments} = await getAssignTaskServices(dataObject);
    return res.status(STATUS_CODES.OK)
      .json(new SuccessResponse(
        STATUS_CODES.OK,
        'Tasks fetched successfully',
        { tasks : assignments }
      ).toJson());
});

export const taskUpdateController = controllerHandler (async (req, res) => {
  const adminId = req.user._id;

  const dataObject = { ...req.body, adminId };

  console.log(dataObject)
  const {task} = await taskUpdateService(dataObject);
    return res.status(STATUS_CODES.OK)
      .json(new SuccessResponse(
        STATUS_CODES.OK,
        'Tasks update successfully',
        task
      ).toJson());
})

export const taskDeleteController = controllerHandler (async (req, res) => {
  const adminId = req.user._id;

  const dataObject = { ...req.query, adminId };


  const {task} = await taskDeleteService(dataObject);
    return res.status(STATUS_CODES.SUCCESS_NO_RESPONSE)
      .json(new SuccessResponse(
        STATUS_CODES.SUCCESS_NO_RESPONSE,
        null,
        null
      ).toJson())
})

export const taskAssignController = controllerHandler(async (req, res) => {
  const adminId = req.user._id;

  const dataObject = { ...req.body, ...req.query, adminId };
  const task = await taskAssignService(dataObject);
  return res.status(STATUS_CODES.OK)
    .json(new SuccessResponse(STATUS_CODES.OK, 'Task assigned successfully', { task }).toJson());
});

export const taskVerifiedController = controllerHandler(async (req, res) => {
  const adminId = req.user._id;

  const dataObject = { ...req.body, ...req.query, adminId };
  const { taskAssignments, message } = await taskVerifiedServices(dataObject);

  return res.status(STATUS_CODES.OK)
    .json(new SuccessResponse(
      STATUS_CODES.OK,
      message || 'Task verified successfully',
      { taskAssignments }
    ).toJson());
});

export const taskStatusChangeController = controllerHandler(async (req, res) => {
  const adminId = req.user._id;

  const dataObject = { ...req.body, ...req.query, adminId };
  const { taskAssignments } = await taskStatusChangeServices(dataObject);

  return res.status(STATUS_CODES.OK)
    .json(new SuccessResponse(
      STATUS_CODES.OK,
      'Task status changed successfully',
      { taskAssignments }
    ).toJson());
});

export const assignTask = controllerHandler(async (req, res) => {
  const adminId = req.user._id;
  const task = await taskAssignService(req.body);
    return res.status(STATUS_CODES.CREATED)
      .json(new SuccessResponse(
        STATUS_CODES.CREATED,
        'Task assigned successfully',
        { task }
      ).toJson());
});

export const completedTask = controllerHandler(async (req, res) => {
  const employeeId = req.user._id;
  const dataObject = { ...req.body, employeeId };

  const result = await taskCompleteService(dataObject);
  return res.status(STATUS_CODES.CREATED).json(
    new SuccessResponse(
      STATUS_CODES.CREATED,
      'Task completed successfully',
      result
    ).toJson()
  );
});

