import { STATUS_CODES } from "../../../../constant.js";
import { adminModel } from "../../../Models/Admin.Model.js";
import { ErrorResponse } from "../../../Utils/Error.js";

/**
 * Service to register a new admin user
 * @param {Object} dataObject - Contains user registration data
 * @returns {Object} - Registered user info and auth tokens
*/

export const adminRegisterService = async (dataObject) => {
    // phoneNumber remove
    const { name, userName, email, password } = dataObject;

    try {
        const existingUser = await adminModel.findOne({ email })
            .lean();

        if (existingUser) {
            throw new ErrorResponse(
                STATUS_CODES.CONFLICT,
                'Email already registered'
            );
        }

        // Create new admin user
        const user = await adminModel({
            name,
            userName,
            email,
            password,  // Password will be hashed by model pre-save hook
            // phoneNumber,
        })

        // Generate auth tokens
        const accessToken = user.generateAccessToken();
        const refreshToken = user.generateRefreshToken();

        // Store refresh token
        user.refreshToken = refreshToken;
        await user.save();


        return { 
            user: user, 
            tokens: { 
                accessToken, 
                refreshToken 
            } 
        };

    } catch (err) {
        if (err instanceof ErrorResponse) {
            throw err;
        }
        throw new ErrorResponse(
            STATUS_CODES.BAD_REQUEST, 
            err.message || 'Registration failed'
        );
    }
};