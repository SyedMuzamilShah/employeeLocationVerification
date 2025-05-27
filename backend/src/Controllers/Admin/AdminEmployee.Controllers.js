import { ErrorResponse } from "../../Utils/Error.js";
import { STATUS_CODES } from "../../../constant.js";
import { employeeCreateServices } from "../../Services/Employee/Employee.Auth.Services.js";
import { SuccessResponse } from "../../Utils/Success.js";
import { controllerHandler } from "../../Utils/ControllerHandler.js";
import { allowImageForProcessService, rejectImageForProcessService } from "../../Services/Admin/Employee/EmployeeManagement.Services.js";
import { employeeDelete, employeeRoleChange, employeeStatusChange, employeeUpdateServices, employeeUpdateToGether, getEmployeeServices } from "../../Services/Combine/Employee.Combine.Services.js";
import fs from "fs";
import path from 'path';

export const employeeAddControllerForAdmin = controllerHandler(async (req, res) => {
    const adminId = req.user._id
    let imagePath = req.file?.path;
    let imageUrl;
    let data = {...req.body, adminId};
    
    try {
        // Check if employee is already registered
        const organizationExist = await employeeCreateServices.finaOrganization(data);
        if (!organizationExist) {
            throw new ErrorResponse(STATUS_CODES.NOT_FOUND, 'Organization not found');
        }

        // Check if employee is already registered
        const existingUser = await employeeCreateServices.findExistingUser(data);
        console.log(existingUser)
        if (existingUser) {
            throw new ErrorResponse(STATUS_CODES.CONFLICT, 'Employee already registered');
        }

        if (imagePath) {

            // imageUrl = await uploadOnCloudinary(imagePath);

            imageUrl = `http://localhost:3000/images/${path.basename(imagePath)}`; // Replace with actual upload logic


            // const { faceToken } = await (imageUrl);
            // biometricToken = faceToken;

            data = { ...data, imageUrl };
        }

        // Create Employee
        const { user, tokens } = await employeeCreateServices.createEmployee(data);

        // Return response
        return res.status(STATUS_CODES.CREATED)
            .json(new SuccessResponse(STATUS_CODES.CREATED, 'Employee created successfully', {
                user: user, tokens
            }).toJson());
            
        // if (imageUrl){
        //     employeeImageAllowControllerForAdmin(req, req.user._id = adminId)
        // }

    } catch (err) {
        console.error("Error creating employee:", err.message);
        throw err instanceof ErrorResponse ? err : new ErrorResponse(STATUS_CODES.INTERNAL_SERVER_ERROR, 'Failed to create employee');
    } finally {
        // Cleanup uploaded file if it exists
        if (imagePath && fs.existsSync(imagePath)) {
            // fs.unlinkSync(imagePath);
        }
    }
});

export const employeeImageAllowControllerForAdmin = controllerHandler(async (req, res) => {

    // Process the image and update user
    const user = await allowImageForProcessService({
        ...req.body,
    });

    // Return success response
    return res.status(STATUS_CODES.SUCCESS_NO_RESPONSE).json(
        new SuccessResponse(
            STATUS_CODES.SUCCESS_NO_RESPONSE,
            'Biometric token generated successfully',
            {
                userId: user._id,
                imageAccepted: user.imageAcceptedForToken,
                biometricTokenGenerated: !!user.biometricToken
            }
        ).toJson()
    );
});

export const employeeImageRejectControllerForAdmin = controllerHandler(async (req, res) => {

    // Process the image and update user
    const user = await rejectImageForProcessService({
        ...req.body,
    });

    // Return success response
    return res.status(STATUS_CODES.SUCCESS_NO_RESPONSE).json(
        new SuccessResponse(
            STATUS_CODES.SUCCESS_NO_RESPONSE,
            'Biometric token generated successfully',
            {
                userId: user._id,
                imageAccepted: user.imageAcceptedForToken,
                biometricTokenGenerated: !!user.biometricToken
            }
        ).toJson()
    );
});

/**
 * * @description Controller for getting employee details for admin
 * * @param {Object} req.query - The request object containing query parameters and user information
 */
export const employeeGetControllerForAdmin = controllerHandler(async (req, res) => {

    const adminId = req.user._id

    const dataObject = {
        ...req.query,
        adminId
    }
    

    const {user} = await getEmployeeServices(dataObject)
    return res.status(STATUS_CODES.OK)
        .json(new SuccessResponse(STATUS_CODES.OK, 'Employee Read successfully', {user}).toJson());
})

export const employeeBasicUpdateControllerForAdmin = controllerHandler(async (req, res) => {
    const adminId = req.user._id

    const dataObject = {
        ...req.body,
        adminId
    }

    const {user} = await employeeUpdateServices(dataObject)
    // console.log(employees)
    return res.status(STATUS_CODES.OK)
        .json(new SuccessResponse(STATUS_CODES.OK, 'Employee Update successfully', {user : user}).toJson());
})

export const employeeUpdateToGetherControllerForAdmin = controllerHandler (async (req, res) => {
    const adminId = req.user._id

    const dataObject = {
        ...req.body,
        adminId
    }

    const {user} = await employeeUpdateToGether(dataObject)
    // console.log(employees)
    return res.status(STATUS_CODES.OK)
        .json(new SuccessResponse(STATUS_CODES.OK, 'Employee Update successfully', {user : user}).toJson());
})

export const employeeStatusChangeControllerForAdmin = controllerHandler(async (req, res) => {

    const adminId = req.user._id
    
    const dataObject = {
        ...req.body,
        adminId
    }

    const {user} = await employeeStatusChange(dataObject)
    // console.log(employees)
    return res.status(STATUS_CODES.SUCCESS_NO_RESPONSE)
        .json(new SuccessResponse(STATUS_CODES.SUCCESS_NO_RESPONSE, 'Employee Status Change successfully', {user : user}).toJson());
})

export const employeeRoleChangeControllerForAdmin = controllerHandler(async (req, res) => {
    const adminId = req.user._id

    console.log(req.query);
    const dataObject = {
        ...req.body,
        adminId
    }

    const {user} = await employeeRoleChange(dataObject)
    // console.log(employees)
    return res.status(STATUS_CODES.SUCCESS_NO_RESPONSE)
        .json(new SuccessResponse(STATUS_CODES.SUCCESS_NO_RESPONSE, 'Employee Status Change successfully', {user : user}).toJson());
})

export const employeeDeleteControllerForAdmin = controllerHandler(async (req, res) => {
    const adminId = req.user._id

    console.log(req.query);
    const dataObject = {
        ...req.body,
        adminId
    }

    const {user} = await employeeDelete(dataObject)
    return res.status(STATUS_CODES.SUCCESS_NO_RESPONSE)
        .json(new SuccessResponse(STATUS_CODES.SUCCESS_NO_RESPONSE, 'Employee Delete successfully', {user : user}).toJson());
})