import mongoose from "mongoose";
import { STATUS_CODES } from "../../../constant.js";
import { employeeModel, EmployeeStatus } from "../../Models/Employee.Model.js"
import { taskAssignmentModel } from "../../Models/TaskAssignment.Model.js";
import { ErrorResponse } from "../../Utils/Error.js";

export const readEmployeeServices = async () => {
    try {
        const employee = await employeeModel.find();
        return employee
    }catch {

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
        
        if (employee.imageAcceptedForToken){
            throw new ErrorResponse(STATUS_CODES.CONFLICT, "Previous one is accepted")
        }

        employee.imageUrl = imageUrl

        await employee.save()
        return {user : employee}

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
  const { employeeId } = dataObject;

  const employee = await employeeModel.findById(employeeId);
  if (!employee) {
    throw new ErrorResponse(404, "Employee not found");
  }

  if (employee.status === EmployeeStatus.PENDING) {
    throw new ErrorResponse(409, "Admin Not Authenticated yet!");
  }

  const tasks = await taskAssignmentModel.aggregate([
    {
      $match: {
        employeeId: new mongoose.Types.ObjectId(employeeId),
      },
    },
    {
      $lookup: {
        from: "tasks", // name of the tasks collection
        localField: "taskId",
        foreignField: "_id",
        as: "taskInfo",
      },
    },
    { $unwind: "$taskInfo" },
    {
      $project: {
        _id: 1,
        employeeId: 1,
        taskId: 1,
        status: 1,
        assignedAt: 1,
        employeeLocation : 1,
        submittedLate : 1,
        submittedAt : 1,
        validateMethod : 1,
        deadline: 1,
        faceVerification : 1,
        pictureAllowed : 1,
        createdAt : 1,
        updatedAt : 1,
        title: "$taskInfo.title",
        description: "$taskInfo.description",
        location: "$taskInfo.location",
        aroundDistanceMeter : "$taskInfo.aroundDistanceMeter"
      },
    },

    {
    $sort: {
      updatedAt: -1, // Change this field to createdAt, submittedAt, etc. as needed
    },
  },
  ]);
  console.log(tasks)
  return { tasks };
};