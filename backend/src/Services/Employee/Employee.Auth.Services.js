import { isValidObjectId } from "mongoose";
import { STATUS_CODES } from "../../../constant.js";
import { employeeModel, EmployeeStatus } from "../../Models/Employee.Model.js";
import { organizationModel } from "../../Models/Organization.Model.js";
import { ErrorResponse } from "../../Utils/Error.js";
import jwt from "jsonwebtoken"

export const employeeCreateServices = {
    findExistingUser: async ({ userName, email }) => {
        return await employeeModel.findOne({ $or: [{ email }, { userName }] }).lean();
    },

    // use for employee
    getOrganizationMongoId: async (dataObject) => {
        const { organizationId } = dataObject;
        if (isValidObjectId(organizationId)) {
            return organizationId; // Already valid
        } else {
            // mean the employee pass custom id
            const org = await organizationModel.findOne({ organizationId }).select('_id');
            return org?._id || null;
        }
    },

    finaOrganization: async ({ organizationId, adminId }) => {
        let org;
        console.log(`Testing the admin ID : ${adminId}`)
        if (adminId){
            org = await organizationModel.findOne({ _id: organizationId, createdBy: adminId });
        }else {
            org = await organizationModel.findOne({ _id: organizationId});
        }
        return org
    },

    createEmployee: async (dataObject) => {
        const { adminId, userName, email, name, password, role, phoneNumber, organizationId, biometricToken, imageUrl } = dataObject;

        try {
            // Create new employee
            const employee = await employeeModel.create({
                userName,
                imageUrl: imageUrl,

                name, email, password, biometricToken, phoneNumber, role: role?.toUpperCase(), organizationId
            });

            // Generate tokens
            let access;
            let refresh;

            if (!adminId) {
                access = employee.generateAccessToken();
                refresh = employee.generateRefreshToken();

                // Save refresh token
                employee.refreshToken = refresh;
            }


            // Admin
            if (adminId) {
                employee.status = EmployeeStatus.VERIFIED;
            }

            await employee.save();


            // Prepare response
            // const userResponse = employee.toObject();
            // delete userResponse.password;
            // delete userResponse.__v;
            // delete userResponse.refreshToken;
            return { user: employee, tokens: { accessToken: access, refreshToken: refresh } };

        } catch (err) {
            console.error("Error in employee creation service:", err.message);
            throw err;
        }
    }
};



export const employeeLoginServices = async (dataObject) => {
    const { email, userName, password } = dataObject;
    try {
        // Find the user by email
        const user = await employeeModel.findOne({
            $or: [{ email }, { userName }]
        }).select('+password');


        if (!user) {
            throw new ErrorResponse(
                STATUS_CODES.NOT_FOUND,
                'Employee is not registered withthat crediational'
            );
        }

        // Validate the password
        const isPasswordValid = await user.isPasswordValid(password);
        console.log("Testing. the password :")
        console.log(isPasswordValid)
        if (!isPasswordValid) {
            throw new ErrorResponse(
                STATUS_CODES.NOT_FOUND,
                'Invalid creadtional'
            );
        }

        // Generate tokens
        const access = await user.generateAccessToken();
        const refresh = await user.generateRefreshToken();

        // Save the refresh token in the database (hashed)
        user.refreshToken = refresh
        await user.save();

        return { userResponse: user, tokens: { accessToken: access, refreshToken: refresh } };
    } catch (err) {
        // Log the error for debugging
        // console.error('Login service error:', err);
        throw err;
    }
}

export const refreshTokenServices = async (dataObject) => {
    const { refreshToken } = dataObject;
    let decode;
    try {
        decode = jwt.verify(refreshToken, process.env.REFRESH_TOKEN_SECRET_KEY);
    } catch (error) {
        if (error.name === 'TokenExpiredError') {
            throw new ErrorResponse(STATUS_CODES.UNAUTHORIZED, "Access token expired");
        } else {
            throw new ErrorResponse(STATUS_CODES.UNAUTHORIZED, "Invalid token");
        }
    }

    const user = await officeAdminModel.findById(decode._id)

    if (!user) {
        throw new ErrorResponse(STATUS_CODES.UNAUTHORIZED, "Access token expired");
    }

    if (!(user.refreshToken == refreshToken)) {
        throw new ErrorResponse(STATUS_CODES.UNAUTHORIZED, "Access token expired");
    }

    const accessToken = user.generateAccessToken()
    const refresh = user.generateRefreshToken()

    const tokens = { accessToken, refreshToken: refresh }

    return tokens
}


export const getEmployeeProfileService = async (userId) => {
    try {
        // Find the user by ID
        const user = await employeeModel.findById(userId);
        if (!user) {
            throw new ErrorResponse(
                STATUS_CODES.NOT_FOUND,
                'User not found'
            );
        }

        // Prepare the response
        const userResponse = user.toObject();
        delete userResponse.password;
        delete userResponse.__v;
        delete userResponse.refreshToken;

        return {user : userResponse};
    } catch (err) {
        // Log the error for debugging
        console.error('Get profile service error:', err);

        // Re-throw custom errors
        if (err instanceof ErrorResponse) {
            throw err;
        }

        // Throw a generic error for unexpected issues
        throw new ErrorResponse(
            STATUS_CODES.INTERNAL_SERVER_ERROR,
            'Profile retrieval failed due to an unexpected error'
        );
    }
};


export const employeeLogOutServices = async (userId) => {
    try {
        // Find the user by ID and remove the refresh token
        const user = await employeeModel.findByIdAndUpdate(userId, {
            $set: { refreshToken: null }
        }, { new: true });

        if (!user) {
            throw new ErrorResponse(
                STATUS_CODES.NOT_FOUND,
                'User not found'
            );
        }

        return true;
    } catch (err) {
        // Log the error for debugging
        console.error('Logout service error:', err);

        // Re-throw custom errors
        if (err instanceof ErrorResponse) {
            throw err;
        }

        // Throw a generic error for unexpected issues
        throw new ErrorResponse(
            STATUS_CODES.INTERNAL_SERVER_ERROR,
            'Logout failed due to an unexpected error'
        );
    }
};


export const employeeChangePasswordServices = async (dataObject) => {
    const { userId, oldPassword, newPassword } = dataObject;
    try {
        // Find the user by ID
        const user = await employeeModel.findById(userId).select('+password');
        if (!user) {
            throw new ErrorResponse(
                STATUS_CODES.NOT_FOUND,
                'User not found'
            );
        }

        // Validate the old password
        const isPasswordValid = await user.isPasswordValid(oldPassword);
        if (!isPasswordValid) {
            throw new ErrorResponse(
                STATUS_CODES.BAD_REQUEST,
                'Old password is not valid'
            );
        }

        // Update the password
        user.password = newPassword;
        await user.save(); // This will trigger the pre-save hook to hash the password

        // Prepare the response
        const userResponse = user.toObject();
        delete userResponse.password;
        delete userResponse.__v;
        delete userResponse.refreshToken;

        return userResponse;
    } catch (err) {
        // Log the error for debugging
        console.error('Change password service error:', err);

        // Re-throw custom errors
        if (err instanceof ErrorResponse) {
            throw err;
        }

        // Throw a generic error for unexpected issues
        throw new ErrorResponse(
            STATUS_CODES.INTERNAL_SERVER_ERROR,
            'Password change failed due to an unexpected error'
        );
    }
};