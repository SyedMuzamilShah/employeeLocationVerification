import { STATUS_CODES } from "../../../constant.js";
import { employeeModel } from "../../Models/Employee.Model.js";
import { taskModel } from "../../Models/Task.Model.js";
import { taskAssignmentModel, taskAssignmentStatus, taskAssignmentValidateMethod } from "../../Models/TaskAssignment.Model.js";
import { calculateDistance } from "../../Utils/Distance_Calculator.js";
import { ErrorResponse } from "../../Utils/Error.js";
import { faceVerification } from "../../Utils/FaceBioHandler.js";
import path from "path"
// 1. Validate Task Assignment
export const validateTaskAssignment = async (employeeId, taskAssignmentId) => {
    const taskAssignment = await taskAssignmentModel.findOne({
        employeeId,
        _id: taskAssignmentId
    });

    if (!taskAssignment) {
        throw new ErrorResponse(STATUS_CODES.NOT_FOUND, "Task Assignment not found");
    }

    if (taskAssignment.status !== taskAssignmentStatus.ASSIGNED) {
        throw new ErrorResponse(
            STATUS_CODES.CONFLICT,
            `Task submission is not allow due to status : ${taskAssignment.status}`
        );
    }

    return taskAssignment;
};

// 2. Validate Employee
export const validateEmployee = async (employeeId) => {
    const employee = await employeeModel.findById(employeeId).select("biometricToken");
    if (!employee) {
        throw new ErrorResponse(STATUS_CODES.NOT_FOUND, "Employee not found");
    }
    return employee;
};

// 3. Validate Task
export const validateTask = async (taskId) => {
    const task = await taskModel.findById(taskId);
    if (!task) {
        throw new ErrorResponse(STATUS_CODES.NOT_FOUND, "Task not found");
    }
    return task;
};

// 4. Set Submission Info
export const setSubmissionInfo = (taskAssignment, deadline) => {
    const submittedAt = new Date();
    const deadlineDate = new Date(deadline);
    const isLate = submittedAt > deadlineDate;

    taskAssignment.checkIn = submittedAt;
    taskAssignment.submittedAt = submittedAt;
    taskAssignment.submittedLate = isLate;

    return { isLate };
};


// 5. Verify Location
export const verifyLocation = (taskLocation, currentLocation, allowedDistance) => {
    const distance = calculateDistance(taskLocation, currentLocation);

    if (distance > allowedDistance) {
        throw new ErrorResponse(
            STATUS_CODES.BAD_REQUEST,
            `You are ${distance - allowedDistance} meters away from the required location`
        );
    }
};

// 6. Handle Face Verification
export const handleFaceVerification = async (taskAssignment, employee, imageUrl, isLate, location) => {
    if (!imageUrl) {
        throw new ErrorResponse(STATUS_CODES.BAD_REQUEST, "Face Image Required");
    }

    if (!employee.biometricToken) {
        throw new ErrorResponse(STATUS_CODES.CONFLICT, "Face not registered");
    }

    // Actual implementation would replace this mock
    const result = await faceVerification(employee.biometricToken, imageUrl);

    // Check if any face detected
    if (!result.faces2 || result.faces2.length === 0) {
        throw new ErrorResponse(
            STATUS_CODES.BAD_REQUEST,
            "Image does not contain a face"
        );
    }
    
    // const confidenceThreshold = result.thresholds["1e-3"]; // medium strictness
    // const confidenceThreshold = result.thresholds["1e-4"]; // medium strictness
    const confidenceThreshold = result.thresholds["1e-5"]; // medium strictness

    console.log(`Threshold  is used : ${confidenceThreshold}`)
    console.log(`Confidence is used : ${result.confidence}`)

    const faceVerified = result.confidence > confidenceThreshold;
    
    if (faceVerified) {
        taskAssignment.threshold = confidenceThreshold
        taskAssignment.confidence = result.confidence

        taskAssignment.employeeLocation = location
        
        taskAssignment.status = taskAssignmentStatus.VERIFIED;
        taskAssignment.validateMethod = taskAssignmentValidateMethod.AUTO;
    } else if (taskAssignment.pictureAllowed) {
        taskAssignment.threshold = confidenceThreshold
        taskAssignment.confidence = result.confidence

        taskAssignment.employeeLocation = location

        taskAssignment.status = taskAssignmentStatus.SUBMITTED;
        // taskAssignment.image = `${config.IMAGE_BASE_URL}/${path.basename(imageUrl)}`;
        taskAssignment.employeeImage = `http://localhost:3000/images/${path.basename(imageUrl)}`;
        taskAssignment.validateMethod = taskAssignmentValidateMethod.MANAULLY;
    } else {
        throw new ErrorResponse(
            STATUS_CODES.BAD_REQUEST,
            "Face verification failed and picture submission is not allowed"
        );
    }

    await taskAssignment.save();
    return {
        method: taskAssignment.validateMethod,
        taskAssignment: taskAssignment
    };
};
