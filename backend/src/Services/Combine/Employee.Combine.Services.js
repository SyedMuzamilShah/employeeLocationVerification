import { isValidObjectId } from "mongoose";
import { STATUS_CODES } from "../../../constant.js";
import { employeeModel } from "../../Models/Employee.Model.js";
import { organizationModel } from "../../Models/Organization.Model.js";
import { ErrorResponse } from "../../Utils/Error.js";


/** 
 *  @description This function retrieves employee data based on the provided filters.
 *  @param {Object} dataObject - The object containing filter criteria and other parameters.
 *  @param {string} dataObject.organizationId - The ID of the organization to filter employees required.
 *  @param {string} dataObject.id - The ID of the employee to retrieve.
 *  @param {string} dataObject.status - The status of the employee (e.g., verfied, block, pending).
 *  @param {string} dataObject.employeeId - The ID of the employee to filter.
 *  @param {string} dataObject.search - The search term for employee name or email.
 *  @param {boolean} dataObject.isEmailVerified - Whether the employee's email is verified.
 *  @param {string} dataObject.role - The role of the employee to filter.
 *  @returns {Array<doc>} - An array of employee documents matching the criteria.
 *  @throws {ErrorResponse} - Throws an error if the query fails or if no employees are found.
*/


export const getEmployeeServices = async (dataObject) => {
    const { adminId, id, organizationId, status, employeeId, isEmailVerified, role, search, imageAcceptedForToken, imageUrl } = dataObject;
    try {
        // Start building the query object
        let query = {};

        // Add filters dynamically if they are provided
        // if (organizationId) query.organizationId = organizationId;
        if (!organizationId) {
            throw new ErrorResponse(STATUS_CODES.BAD_REQUEST, 'Organization ID is required');
        }

        query.organizationId = organizationId

        if (id) query._id = id;
        // if (adminId) query.createdBy = adminId;
        if (imageAcceptedForToken) query.imageAcceptedForToken = imageAcceptedForToken;
        if (imageUrl) query.imageUrl = imageUrl;
        if (status) {
            if (status.toLowerCase() !== 'all') {
                query.status = status.toUpperCase();
            }
        };
        if (employeeId) query.employeeId = employeeId;
        if (typeof isEmailVerified === "boolean") query.isEmailVerified = isEmailVerified;
        if (role) query.role = role;
        // Add text search if provided
        if (search) {
            query.$or = [
                { userName: { $regex: search, $options: 'i' } },
                { name: { $regex: search, $options: 'i' } },
                { email: { $regex: search, $options: 'i' } },
                { employeeId: { $regex: search, $options: 'i' } },
                { role: { $regex: search, $options: 'i' } }
            ];
        }
        console.log(query)
        let employees;
        if (adminId){
            employees = await employeeModel.find(query).select('+imageAcceptedForToken');
        }else {
            employees = await employeeModel.find(query);
        }

        return { user: employees };
    } catch (error) {

        if (error.name === "CastError") {
            throw new ErrorResponse(
                STATUS_CODES.BAD_REQUEST,
                `Invalid ID format: ${error.message}`
            );
        }

        throw new ErrorResponse(
            STATUS_CODES.INTERNAL_SERVER_ERROR,
            `Error fetching employees: ${error.message}`
        );
    }
};


export const employeeUpdateServices = async (dataObject) => {
    const { employeeId } = dataObject
    const employee = await employeeModel.findById(employeeId);
    if (!employee) {
        throw new ErrorResponse(STATUS_CODES.NOT_FOUND, 'Employee not found');
    }
    // Define fields allowed to be updated
    const allowedFields = [
        'name',
        'phoneNumber',
    ];

    // update the employee data in database
    // Loop through allowed fields and update the employee object
    for (const key of allowedFields) {
        if (dataObject[key] !== undefined) {
            employee[key] = dataObject[key];
        }
    }

    await employee.save();

    return { user: employee };
}

export const employeeUpdateToGether = async (dataObject) => {
    console.log(dataObject)
    const { employeeId } = dataObject
    const employee = await employeeModel.findById(employeeId);
    if (!employee) {
        throw new ErrorResponse(STATUS_CODES.NOT_FOUND, 'Employee not found');
    }
    // Define fields allowed to be updated
    const allowedFields = [
        'name',
        'phoneNumber',
        'role',
        'status',
        "uploadNewImage"
    ];

    // update the employee data in database
    // Loop through allowed fields and update the employee object
    for (const key of allowedFields) {
        if (dataObject[key] !== undefined) {
            if (key === allowedFields[2] || key === allowedFields[3]) {
                employee[key] = dataObject[key].toUpperCase();
                continue;
            }
            employee[key] = dataObject[key];
        }
    }

    await employee.save();

    return { user: employee };
}

export const employeeStatusChange = async (dataObject) => {
    const { adminId, employeeId, status } = dataObject;
    const employee = await employeeModel.findById(employeeId);
    if (!employee) {
        throw new ErrorResponse(STATUS_CODES.NOT_FOUND, 'Employee not found');
    }

    const isOrg = await organizationModel.findOne({_id : employee.organizationId, createdBy : adminId})

    if (!isOrg){
        throw new ErrorResponse(STATUS_CODES.NOT_FOUND, 'Employee Is not registerd');
    }

    employee.status = status.toUpperCase();
    await employee.save();
    return { user: employee };
}

export const employeeRoleChange = async (dataObject) => {
    const { adminId, employeeId, role } = dataObject;

    const employee = await employeeModel.findById(employeeId);
    if (!employee) {
        throw new ErrorResponse(STATUS_CODES.NOT_FOUND, 'Employee not found');
    }

    let isOrg;
    if (isValidObjectId(employee.organizationId)){
        isOrg = await organizationModel.findOne({_id : employee.organizationId, createdBy : adminId})
    }else {
        isOrg = await organizationModel.findOne({organizationId : employee.organizationId, createdBy : adminId})
    }
    
    if (!isOrg){
        throw new ErrorResponse(STATUS_CODES.NOT_FOUND, 'Employee Is not registerd');
    }

    employee.role = role.toUpperCase();
    await employee.save();
    return { user: employee };
}

export const employeeDelete = async (dataObject) => {
    const { adminId, employeeId } = dataObject;

    const employee = await employeeModel.findByIdAndDelete(employeeId);
    if (!employee) {
        throw new ErrorResponse(STATUS_CODES.NOT_FOUND, 'Employee not found');
    }

    return { user: true };
}