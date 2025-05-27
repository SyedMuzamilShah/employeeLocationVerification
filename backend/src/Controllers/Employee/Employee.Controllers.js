import path from "path"
import { STATUS_CODES } from "../../../constant.js";
import { ErrorResponse } from "../../Utils/Error.js";
import { validationResult } from 'express-validator';
import { SuccessResponse } from "../../Utils/Success.js";
import { controllerHandler } from "../../Utils/ControllerHandler.js";
import { deleteImage } from "../../Utils/DeleteImageFromLocalServer.js"
import { employeeImageUploadServices } from "../../Services/Employee/Employee.Services.js";
import { employeeCreateServices, employeeLoginServices, employeeLogOutServices, getEmployeeProfileService } from "../../Services/Employee/Employee.Auth.Services.js";

export const employeeRegisterController = controllerHandler(async (req, res) => {
    let imagePath = req.file?.path;
    let imageUrl, biometricToken;
    let data = req.body;
    console.log(data)
    const orgID = await employeeCreateServices.getOrganizationMongoId(data)
    if (!orgID){
      throw new ErrorResponse(STATUS_CODES.BAD_REQUEST, 'Organization is not correct');
    }
    data.organizationId = orgID
    
    try {
        // Check if employee is already registered
        const organizationExist = await employeeCreateServices.finaOrganization(data);
        console.log(organizationExist)
        if (!organizationExist) {
            console.log("Organization not found");
            throw new ErrorResponse(STATUS_CODES.NOT_FOUND, 'Organization not found');
        }

        // Check if employee is already registered
        const existingUser = await employeeCreateServices.findExistingUser(data);
        if (existingUser) {
            throw new ErrorResponse(STATUS_CODES.CONFLICT, 'Employee already registered');
        }

        if (imagePath) {
            console.log("Uploading image to Cloudinary...");
            imageUrl = imagePath;
            // imageUrl = await uploadOnCloudinary(imagePath);

            console.log("Generating face biometric token...");
            biometricToken = "Token hold"
            // const { faceToken } = await faceRegistration(imageUrl);
            // biometricToken = faceToken;

            data = { ...data, biometricToken, imageUrl };
        }

        // Create Employee
        const { user, tokens } = await employeeCreateServices.createEmployee(data);

        // Return response
        return res.status(STATUS_CODES.CREATED)
            .json(new SuccessResponse(STATUS_CODES.CREATED, 'Employee created successfully', {
                user: user, tokens
            }).toJson());

    } catch (err) {
        console.error("Error creating employee:", err.message);
        throw err instanceof ErrorResponse ? err : new ErrorResponse(STATUS_CODES.INTERNAL_SERVER_ERROR, 'Failed to create employee');
    } finally {
        // // Cleanup uploaded file if it exists
        // deleteImage(imagePath)
    }
});

export const employeeLoginController = controllerHandler(async (req, res) => {
  // Validate the request
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    throw new ErrorResponse(
      STATUS_CODES.BAD_REQUEST,
      'Validation failed',
      errors.array()
    );
  }

  // Call the login service
  const { userResponse, tokens } = await employeeLoginServices(req.body);

  // Return success response
  res.status(STATUS_CODES.OK).json(
    new SuccessResponse(
      STATUS_CODES.OK,
      'Login successful',
      { user: userResponse, tokens: tokens }
    ).toJson()
  );
});

export const employeeLogoutController = controllerHandler(async (req, res) => {
  const userId = req.user._id; // Assuming the user ID is available in `req.user`
  // Call the logout service
  const logout = await employeeLogOutServices(userId);

  if (logout) {
    // Return success response
    return res.status(STATUS_CODES.OK).json(
      new SuccessResponse(
        STATUS_CODES.OK,
        'Logout successful',
        undefined
      ).toJson()
    );
  }
});

export const employeeImageUploadController = controllerHandler(async (req, res) => {
    const employeeId = req.user._id;
    let imagePath = req.file?.path;
    let imageUrl;
    let data = req.body;
    if (!imagePath) {
      throw new ErrorResponse(STATUS_CODES.BAD_REQUEST, 'Image file is required');
    }
    
    try {
          console.log("Uploading image to Cloudinary...");

            // imageUrl = await uploadOnCloudinary(imagePath);
          imageUrl = `http://localhost:3000/images/${path.basename(imagePath)}`; // Replace with actual upload logic

            console.log("Generating face biometric token...");

            data = { ...data , imageUrl, employeeId };

        // Create Employee
        const { user } = await employeeImageUploadServices(data);

        // Return response
        return res.status(STATUS_CODES.OK)
            .json(new SuccessResponse(STATUS_CODES.OK, 'Employee Image Uploaded', {
                user: user
            }).toJson());

    } catch (err) {
        console.error("Error creating employee:", err.message);
        deleteImage(imagePath)
        throw err instanceof ErrorResponse ? err : new ErrorResponse(STATUS_CODES.INTERNAL_SERVER_ERROR, 'Failed to create employee');
    } finally {
        // // Cleanup uploaded file if it exists
    }
});

export const employeeProfileGetController = controllerHandler(async (req, res)=> {
    const userId = req.user._id; // Assuming the user ID is available in `req.user`
  
    try {
      // Call the get profile service
      const { user } = await getEmployeeProfileService(userId);
  
      // Return success response
      return res.status(STATUS_CODES.OK).json(
        new SuccessResponse(
          STATUS_CODES.OK,
          'Profile fetched successfully',
          { user }
        ).toJson()
      );
    } catch (err) {
      // Handle specific errors
      if (err instanceof ErrorResponse) {
        throw err;
      }
  
      // Handle unexpected errors
      throw new ErrorResponse(
        STATUS_CODES.INTERNAL_SERVER_ERROR,
        'Failed to fetch profile due to an unexpected error'
      );
    }
})

export const employeeForgotPasswordController = controllerHandler(async (req, res) => {
  res.send("Not Implemented Yet")
});

export const employeeChangePasswordController = controllerHandler(async (req, res) => {
  res.send("Not Implemented Yet")
});


