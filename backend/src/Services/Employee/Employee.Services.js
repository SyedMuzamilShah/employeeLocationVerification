import { STATUS_CODES } from "../../../constant.js";
import { employeeModel } from "../../Models/Employee.Model.js"
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
    const { employeeId } =  dataObject
    const task = await taskAssignmentModel.find({employeeId : employeeId})

    return {task}
}