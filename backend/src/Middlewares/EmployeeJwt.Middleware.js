import { controllerHandler } from '../Utils/ControllerHandler.js'
import { ErrorResponse } from '../Utils/Error.js'
import { STATUS_CODES } from '../../constant.js'
import jwt from 'jsonwebtoken'
import { employeeModel } from '../Models/Employee.Model.js'


export const employeeJWTDecode = controllerHandler(async (req, _, next) => {
    try {
        // Get access token from web cookies or frontend header
        const token = req.cookies?.accessToken || req.header("Authorization")?.replace("Bearer ", "");
        // console.log(token)
        // If access token is not present, throw an error
        if (!token) {
            throw new ErrorResponse(STATUS_CODES.UNAUTHORIZED, "Access token is required");
        }

        // Decode the access token
        let decode;
        try {
            decode = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET_KEY);
        } catch (error) {
            console.log(error.name)
            if (error.name === 'TokenExpiredError') {
                throw new ErrorResponse(STATUS_CODES.UNAUTHORIZED, "Access token expired");
            } else {
                throw new ErrorResponse(STATUS_CODES.UNAUTHORIZED, "Invalid token");
            }
        }

        // Find the user in the database
        const user = await employeeModel.findById(decode?._id);

        // If user not found, throw an error
        if (!user) {
            throw new ErrorResponse(STATUS_CODES.UNAUTHORIZED, "User not found");
        }
        
        // If refreshToken is null, block access (User is logged out)
        if (user.refreshToken == null) {
            throw new ErrorResponse(STATUS_CODES.UNAUTHORIZED, "User is logged out. Please log in again.");
        }

        // Attach user data to the request object
        req.user = user;

        // Move forward
        next();
    } catch (err) {
        // Pass the error to Express error handling
        next(err);
    }
});