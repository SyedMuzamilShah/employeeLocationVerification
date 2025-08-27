import mongoose from "mongoose";
import { STATUS_CODES } from "../../../constant.js";
import { employeeModel, EmployeeStatus } from "../../Models/Employee.Model.js"
import { taskAssignmentModel } from "../../Models/TaskAssignment.Model.js";
import { ErrorResponse } from "../../Utils/Error.js";

export const readEmployeeServices = async () => {
  try {
    const employee = await employeeModel.find();
    return employee
  } catch {

  }
}



export const employeeImageUploadServices = async (dataObject) => {
  const { employeeId, imageUrl, organizationId } = dataObject
  console.log(dataObject)
  try {
    const employee = await employeeModel.findOne(
      {
        $and: [
          // { _id: employeeId }, {organizationId : organizationId}
          { _id: employeeId }
        ]
      }
    ).select("imageAcceptedForToken")

    if (!employee) {
      throw new ErrorResponse(STATUS_CODES.NOT_FOUND, "Employee Id not found")
    }

    if (employee.imageAcceptedForToken) {
      throw new ErrorResponse(STATUS_CODES.CONFLICT, "Previous one is accepted")
    }

    employee.imageUrl = imageUrl

    await employee.save()
    return { user: employee }

  } catch (err) {

    // Re-throw custom errors
    if (err instanceof ErrorResponse) {
      throw err;
    }

    // Throw a generic error for unexpected issues
    throw new ErrorResponse(
      STATUS_CODES.INTERNAL_SERVER_ERROR,
      'failed to set image'
    );
  }
}

export const employeeAssignTaskReadService = async (dataObject) => {
  const { employeeId, search, status, checkIn, checkOut, dueDate } = dataObject;
  console.log(status)
  console.log("Testing the objective of main course")
  const employee = await employeeModel.findById(employeeId);
  if (!employee) {
    throw new ErrorResponse(404, "Employee not found");
  }

  if (employee.status === EmployeeStatus.PENDING) {
    throw new ErrorResponse(409, "Admin Not Authenticated yet!");
  }
  if (employee.status === EmployeeStatus.BLOCKED) {
    throw new ErrorResponse(409, "Admin Blocked");
  }

  const matchStage = {
    employeeId: new mongoose.Types.ObjectId(employeeId),
  };

    if (status && status.toUpperCase() !== "ALL") {
      matchStage.status = status.toUpperCase();
  }

  if (checkIn) {
    matchStage.checkIn = { $gte: new Date(checkIn) }; // >= provided date
  }

  if (checkOut) {
    matchStage.checkOut = { $lte: new Date(checkOut) }; // <= provided date
  }

  if (dueDate) {
    matchStage.deadline = { $eq: new Date(dueDate) }; // match exact deadline
  }
  const tasks = await taskAssignmentModel.aggregate([
    { $match: matchStage },
    {
      $lookup: {
        from: "tasks",
        localField: "taskId",
        foreignField: "_id",
        as: "taskInfo",
      },
    },
    { $unwind: "$taskInfo" },

    // apply search filter after join
    ...(search
      ? [
          {
            $match: {
              $or: [
                { "taskInfo.title": { $regex: search, $options: "i" } },
                { "taskInfo.description": { $regex: search, $options: "i" } },
              ],
            },
          },
        ]
      : []),

    {
      $project: {
        _id: 1,
        employeeId: 1,
        taskId: 1,
        status: 1,
        assignedAt: 1,
        employeeLocation: 1,
        submittedLate: 1,
        submittedAt: 1,
        validateMethod: 1,
        deadline: 1,
        faceVerification: 1,
        pictureAllowed: 1,
        createdAt: 1,
        updatedAt: 1,
        title: "$taskInfo.title",
        description: "$taskInfo.description",
        location: "$taskInfo.location",
        checkOut: 1,
        checkIn: 1,
        aroundDistanceMeter: "$taskInfo.aroundDistanceMeter",
      },
    },
    { $sort: { updatedAt: -1 } },
  ]);
  console.log("COMMING")
  return { tasks };
};