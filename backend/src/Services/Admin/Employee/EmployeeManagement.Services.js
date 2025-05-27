import { STATUS_CODES } from "../../../../constant.js";
import { employeeModel } from "../../../Models/Employee.Model.js";
import { ErrorResponse } from "../../../Utils/Error.js";
import { faceRegistration, registerLocalImage } from "../../../Utils/FaceBioHandler.js";
import path from "path";
import fs from 'fs';

export const allowImageForProcessService = async (dataObject) => {
    const { employeeId } = dataObject;

    try {
        // Validate input
        if (!employeeId) {
            throw new ErrorResponse(
                STATUS_CODES.BAD_REQUEST,
                'Employee ID is required'
            );
        }

        // Find the user by ID with necessary fields
        const user = await employeeModel.findById(employeeId)
            .select('imageUrl imageAcceptedForToken biometricToken');
        
        if (!user) {
            throw new ErrorResponse(
                STATUS_CODES.NOT_FOUND,
                'User not found'
            );
        }
        if (user.biometricToken) {
            throw new ErrorResponse(
                STATUS_CODES.BAD_REQUEST,
                'Biometric token already exists'
            );
        }
        if (!user.imageUrl) {
            throw new ErrorResponse(
                STATUS_CODES.NOT_FOUND,
                'Profile image not found'
            );
        }

        // Process image based on storage location
        let faceToken;
        if (user.imageUrl.includes('localhost')) {

            // Process local image
            // create the path
            const imageName = path.basename(user.imageUrl);
            const imagePath = path.join(process.cwd(), 'public', 'temp', imageName);

            console.log('Processing image at:', imagePath); // Debug log

            // Verify image exists
            if (!fs.existsSync(imagePath)) {
                throw new ErrorResponse(404, 'Image file not found on server');
            }

            const result = await registerLocalImage(imagePath);
            faceToken = result.faceToken;
        } else {
            // Remote image processing
            const result = await faceRegistration(user.imageUrl);
            faceToken = result.faceToken;
        }

        // Update user record
        user.imageAcceptedForToken = true;
        user.biometricToken = faceToken;
        user.markModified('biometricToken'); // Ensure Mongoose saves the change

        await user.save();

        return {
            success: true,
            data: {
                employeeId: user._id,
                imageAccepted: user.imageAcceptedForToken,
                biometricTokenUpdated: !!faceToken
            }
        };

    } catch (error) {
        if (error instanceof ErrorResponse) {
            throw error;
        }

        console.error('Image processing error:', error);

        // Handle specific face registration errors
        if (error.message.includes('Face detection failed')) {
            throw new ErrorResponse(
                STATUS_CODES.UNPROCESSABLE_ENTITY,
                'No face detected in the provided image'
            );
        }

        // Re-throw known error types
        if (error instanceof ErrorResponse) {
            throw error;
        }

        // Handle unexpected errors
        throw new ErrorResponse(
            STATUS_CODES.INTERNAL_SERVER_ERROR,
            'Failed to process image for biometric token'
        );
    }
};

export const rejectImageForProcessService = async (dataObject) => {
    const { employeeId } = dataObject;

    try {
        // Validate input
        if (!employeeId) {
            throw new ErrorResponse(
                STATUS_CODES.BAD_REQUEST,
                'Employee ID is required'
            );
        }
        
        await employeeModel.findByIdAndUpdate(employeeId, {
            imageUrl : null
        })
        
        return {
            success: true,
            // data: {
            //     employeeId: user._id,
            //     imageAccepted: user.imageAcceptedForToken,
            //     biometricTokenUpdated: !!faceToken
            // }
        };

    } catch (error) {
        if (error instanceof ErrorResponse) {
            throw error;
        }

        console.error('Image processing error:', error);

        // Handle specific face registration errors
        if (error.message.includes('Face detection failed')) {
            throw new ErrorResponse(
                STATUS_CODES.UNPROCESSABLE_ENTITY,
                'No face detected in the provided image'
            );
        }

        // Re-throw known error types
        if (error instanceof ErrorResponse) {
            throw error;
        }

        // Handle unexpected errors
        throw new ErrorResponse(
            STATUS_CODES.INTERNAL_SERVER_ERROR,
            'Failed to process image for biometric token'
        );
    }
};