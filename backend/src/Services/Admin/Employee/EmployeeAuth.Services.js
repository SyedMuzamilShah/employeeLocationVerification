import { employeeModel } from "../../../Models/Employee.Model.js";
import { ErrorResponse } from "../../../Utils/Error.js";

/**
 * Service to change admin password
 * @param {Object} dataObject - Contains userId, old and new passwords
 * @returns {Object} - Updated user info
 */
export const employeeChangePasswordService = async (dataObject) => {
    const { userId, oldPassword, newPassword } = dataObject;
    
    try {
        // Find user including password field
        const user = await employeeModel.findById(userId)
            .select('+password')
            .exec();

        if (!user) {
            throw new ErrorResponse(
                STATUS_CODES.NOT_FOUND,
                'User not found'
            );
        }

        // Validate old password
        const isPasswordValid = await user.isPasswordValid(oldPassword);
        if (!isPasswordValid) {
            throw new ErrorResponse(
                STATUS_CODES.UNAUTHORIZED,
                'Current password is incorrect'
            );
        }

        // Prevent setting same password
        if (oldPassword === newPassword) {
            throw new ErrorResponse(
                STATUS_CODES.BAD_REQUEST,
                'New password must be different'
            );
        }

        // Update password (auto-hashed by pre-save hook)

        console.log("Password changed in employee....")
        console.log(user.password)
        console.log(newPassword)
        user.password = newPassword;
        await user.save();

        // Prepare clean response
        const userResponse = user.toObject();
        delete userResponse.password;
        delete userResponse.__v;
        delete userResponse.refreshToken;

        return { user: userResponse };
    } catch (err) {
        if (err instanceof ErrorResponse) {
            throw err;
        }
        throw new ErrorResponse(
            STATUS_CODES.INTERNAL_SERVER_ERROR,
            'Password change failed'
        );
    }
};