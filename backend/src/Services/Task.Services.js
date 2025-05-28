import { STATUS_CODES } from "../../constant.js";
import { employeeModel } from "../Models/Employee.Model.js";
import { organizationModel } from "../Models/Organization.Model.js";
import { taskModel } from "../Models/Task.Model.js";
import { taskAssignmentModel, taskAssignmentStatus, taskAssignmentValidateMethod } from "../Models/TaskAssignment.Model.js";
import { ErrorResponse } from "../Utils/Error.js";
import { faceVerification } from "../Utils/FaceBioHandler.js";
import { calculateDistance, getDistanceInMeters } from "../Utils/Distance_Calculator.js"
import mongoose, { isValidObjectId } from "mongoose";
import path from "path"
import { handleFaceVerification, setSubmissionInfo, validateEmployee, validateTask, validateTaskAssignment, verifyLocation } from "./TaskFunction/TaskCompletion.Method.js";
const handleDatabaseError = (error) => {
    console.error("Database error:", error.message);
    throw new ErrorResponse(500, error.message ?? "An unexpected database error occurred");
};

export const taskCreateServices = async (dataObject) => {
    try {
        const {
            adminId,
            title,
            description,
            organizationId,
            aroundDistanceMeter,
            radius,
            location,
            dueDate,
        } = dataObject;
        console.log(dataObject)
        console.log(radius)
        let query
        query = { _id: organizationId, createdBy: adminId }

        // 🔍 Check if organization exists
        const org = await organizationModel.findOne(query);

        if (!org) throw new ErrorResponse(400, 'Organization not found');

        // ✅ Check for duplicate task
        const existingTask = await taskModel.findOne({
            title,
            description,
            organizationId: org._id,
            location,
            dueDate: new Date(dueDate),
        });
        if (existingTask) {
            throw new ErrorResponse(400, 'A task with this title and due date already exists for this organization');
        }

        const taskData = {
            organizationId: org._id,
            adminId,
            title,
            description,
            dueDate: new Date(dueDate),
            status: "CREATED",
        };

        if (location) {
            taskData.location = location;
        }
        if (radius) {
            // taskData.aroundDistanceMeter = aroundDistanceMeter;
            taskData.aroundDistanceMeter = radius;
        }

        const newTask = new taskModel(taskData);
        const task = await newTask.save();

        return { task };
    } catch (error) {
        handleDatabaseError(error);
    }
};

export const taskUpdateService = async (dataObject) => {
    try {
        const { taskId } = dataObject;
        const task = await taskModel.findById(taskId);
        if (!task) {
            throw new ErrorResponse(STATUS_CODES.NOT_FOUND, "Task not found");
        }

        const allowedFields = ['title', 'name', 'description', 'status', 'dueDate', 'location', 'aroundDistanceMeter'];

        for (const key of allowedFields) {
            if (dataObject[key] !== undefined) {
                task[key] = dataObject[key];
            }
        }
        await task.save();
        console.log(task)
        return { task };
    } catch (err) {
        throw new ErrorResponse(STATUS_CODES.NOT_FOUND, err.message);
    }
};

export const taskReadService = async () => {
    try {
        const tasks = await taskModel.find().sort({ createdAt: -1 }).lean();
        return { tasks };
    } catch (error) {
        console.error("Error in taskReadService:", error.message);
        return {
            success: false,
            message: error.message || "Failed to fetch tasks",
            data: null,
        };
    }
};

export const taskDeleteService = async (dataObject) => {
    try {
        const { taskId } = dataObject;

        const response = await taskModel.findByIdAndDelete(taskId);
        // taskModel.deleteMany
        console.log(response)
        // if task is deleted then delete all the task from task assignment model
        // if the task is deleted then it will be deleted from that corresponding assignment employees
        await taskAssignmentModel.deleteMany({ taskId: taskId });

        if (!response) throw new ErrorResponse(STATUS_CODES.NOT_FOUND, "Task not found");
        return true;
    } catch (err) {
        throw new ErrorResponse(500, err.message ?? 'Unexpected error occurred');
    }
};

export const taskAssignService = async (dataObject) => {
    let { employeesId, taskId, adminId, deadline } = dataObject;
    if (!Array.isArray(employeesId)) {
        employeesId = [employeesId];
    }

    try {
        console.log("Task Assign Services")
        console.log(dataObject)
        const task = await taskModel.findById(taskId);
        if (!task) throw new ErrorResponse(404, "Task not found");

        const alreadyAssigned = [];
        const newAssignments = [];

        for (const employee of employeesId) {
            const { employeeId, pictureAllowed, faceVerification } = employee;

            const employeeExists = await employeeModel.findOne({
                _id: employeeId,
                organizationId: task.organizationId,
            });

            if (!employeeExists) {
                throw new ErrorResponse(404, `Employee with ID ${employeeId} not found`);
            }

            const exists = await taskAssignmentModel.findOne({ taskId, employeeId });
            if (exists) {
                alreadyAssigned.push(employeeId);
                continue;
            }

            const assignment = await taskAssignmentModel.create({
                assignedBy: adminId,
                employeeId,
                taskId,
                deadline: deadline ?? task.dueDate,
                pictureAllowed: pictureAllowed,
                faceVerification : faceVerification
            });

            newAssignments.push(assignment);
        }


        if (newAssignments.length > 0) {
            task.status = "ASSIGNED";
            await task.save();
        }

        return {
            assignments: newAssignments,
            alreadyAssigned,
        };
    } catch (err) {
        throw new ErrorResponse(400, err.message);
    }
};

export const taskDeAssignServices = async (dataObject) => {
    try {
        const { employeeId, taskId } = dataObject;
        const task = await taskModel.findById(taskId);
        if (!task) throw new ErrorResponse(404, "Task not found");

        const assignment = await taskAssignmentModel.findOne({ taskId, employeeId });
        if (!assignment) throw new ErrorResponse(400, "Task not assigned to this employee");

        await taskAssignmentModel.findByIdAndDelete(assignment._id);

        task.status = "CREATED"; // Revert the task status back to "CREATED"
        await task.save();

        return { task };
    } catch (err) {
        throw new ErrorResponse(400, err.message);
    }
};

export const taskVerifiedServices = async (dataObject) => {
    try {
        console.log(dataObject)
        let { employeesId, taskId } = dataObject;
        if (!Array.isArray(employeesId)) {
            employeesId = [employeesId];
        }

        const taskAssignments = await taskAssignmentModel.find({
            taskId,
            employeeId: { $in: employeesId },
        });
        console.log(taskAssignments)
        if (taskAssignments.length === 0) {
            throw new ErrorResponse(404, "No task assignments found for given employee(s)");
        }

        const updatedAssignments = [];

        for (const assignment of taskAssignments) {
            if (assignment.status === "VERIFIED") {
                continue;
            }

            assignment.status = "VERIFIED";
            await assignment.save();
            updatedAssignments.push(assignment);
        }

        return {
            taskAssignments: updatedAssignments,
            message: `${updatedAssignments.length} assignment(s) marked as VERIFIED`,
        };
    } catch (err) {
        throw new ErrorResponse(400, err.message);
    }
};

export const taskStatusChangeServices = async (dataObject) => {
    try {
        let { employeesId, taskId, status } = dataObject;
        if (!Array.isArray(employeesId)) {
            employeesId = [employeesId];
        }

        const taskAssignments = await taskAssignmentModel.find({
            taskId,
            employeeId: { $in: employeesId },
        });

        if (taskAssignments.length === 0) {
            throw new ErrorResponse(404, "No task assignments found for given employee(s)");
        }

        const updatedAssignments = [];
        for (const assignment of taskAssignments) {
            assignment.status = status.toUpperCase();
            await assignment.save();
            updatedAssignments.push(assignment);
        }

        return { taskAssignments: updatedAssignments };
    } catch (err) {
        throw new ErrorResponse(400, err.message);
    }
};


export const getTasksWithAssignments = async (dataObject) => {
    const { adminId, organizationId, status, search, taskId } = dataObject;
    console.log(dataObject)
    try {
        const isorganizationExistsOrg = await organizationModel.findById({ _id: organizationId, createdBy: adminId })
        if (!isorganizationExistsOrg) {
            throw new ErrorResponse(STATUS_CODES.NOT_FOUND, "Organization not found");
        }

        // const taskExists = await taskModel.findOne({ organizationId, adminId : adminId });
        // if (!taskExists) {
        //     throw new ErrorResponse(STATUS_CODES.NOT_FOUND, "task not found");
        // }

        let query = {
            organizationId,
            adminId
        };

        if(taskId){
            query._id = taskId
        }
        if (status && status.toUpperCase() !== "ALL") {
            query.status = status.toUpperCase();
        }

        if (search) {
            query.$or = [
                { title: { $regex: search, $options: "i" } },
                { description: { $regex: search, $options: "i" } }
            ];
        }

        const tasks = await taskModel.find(query).sort({createdAt : -1}).lean();
        const taskIds = tasks.map((task) => task._id);

        const assignments = await taskAssignmentModel.find({
            taskId: { $in: taskIds }
        }).lean();

        const taskAssignmentsMap = assignments.reduce((acc, assignment) => {
            const taskIdStr = assignment.taskId.toString();
            if (!acc[taskIdStr]) acc[taskIdStr] = [];
            acc[taskIdStr].push(assignment.employeeId);
            return acc;
        }, {});

        const tasksWithAssignment = tasks.map((task) => ({
            ...task,
            // assignment: taskAssignmentsMap[task._id.toString()] || []
            assignment: assignments
        }));

        return { tasks: tasksWithAssignment };
    } catch (error) {
        console.error("Error fetching tasks:", error);

        if (error.name === "CastError") {
            throw new ErrorResponse(
                STATUS_CODES.BAD_REQUEST,
                `Invalid ID format: ${error.message}`
            );
        }

        throw new ErrorResponse(
            error.statusCode ?? STATUS_CODES.INTERNAL_SERVER_ERROR,
            `${error.message}`
        );
    }
};


export const getAssignTaskServices = async (dataObject) => {
    const { adminId, organizationId, status, search, taskId } = dataObject;
    console.log(dataObject);
    try {
        // Optional: Check organization
        // const isorganizationExistsOrg = await organizationModel.findOne({ _id: organizationId, createdBy: adminId });
        // if (!isorganizationExistsOrg) {
        //     throw new ErrorResponse(STATUS_CODES.NOT_FOUND, "Organization not found");
        // }

        const taskExists = await taskModel.findById(taskId);
        if (!taskExists) {
            throw new ErrorResponse(STATUS_CODES.NOT_FOUND, "Task not found");
        }

        const matchStage = {
            taskId: new mongoose.Types.ObjectId(taskId),
        };

        if (status && status.toUpperCase() !== "ALL") {
            matchStage.status = status.toUpperCase();
        }

        console.log("matchStage:", matchStage);

        const pipeline = [
            { $match: matchStage },

            // Join with employeeModel
            {
                $lookup: {
                    from: "employees",
                    localField: "employeeId",
                    foreignField: "_id",
                    as: "employee"
                }
            },
            { $unwind: "$employee" },

            // Join with taskModel to get location
            {
                $lookup: {
                    from: "tasks",
                    localField: "taskId",
                    foreignField: "_id",
                    as: "task"
                }
            },
            { $unwind: "$task" },

            // Optional search
            ...(search ? [{
                $match: {
                    $or: [
                        { "employee.userName": { $regex: search, $options: "i" } },
                        { "employee.email": { $regex: search, $options: "i" } }
                    ]
                }
            }] : []),

            // Final projection
            {
                $addFields: {
                    taskLocation: "$task.location", // Flatten the task.location to top level
                    taskLocationRadius : "$task.aroundDistanceMeter"

                }
              },
            {
                $project: {
                    _id: 0,
                    taskId: 1,
                    status: 1,
                    submittedLate: 1,
                    validateMethod: 1,
                    deadline: 1,
                    submittedAt: 1,
                    faceVerification: 1,
                    pictureAllowed: 1,
                    employeeImage: 1,
                    employeeLocation: 1,
                    confidence: 1,
                    // location: "$task.location",
                    
                    // "task.location": 1,
                    taskLocation : 1,
                    taskLocationRadius : 1,
                    "employee.email": 1,
                    "employee._id" : 1,
                    "employee.userName": 1,
                    "employee.imageUrl": 1
                }
            }
        ];

        const result = await taskAssignmentModel.aggregate(pipeline);
        console.log("Result:", result);
        return { assignments: result };

    } catch (error) {
        console.error("Error in getAssignTaskServices:", error);

        if (error.name === "CastError") {
            throw new ErrorResponse(
                STATUS_CODES.BAD_REQUEST,
                `Invalid ID format: ${error.message}`
            );
        }

        throw new ErrorResponse(
            error.statusCode ?? STATUS_CODES.INTERNAL_SERVER_ERROR,
            `${error.message}`
        );
    }
};


export const taskCompleteService = async (dataObject) => {
    const { employeeId, imageUrl, location, organizationId, taskAssignmentId } = dataObject;

    // 1. Validate task assignment
    const taskAssignment = await validateTaskAssignment(employeeId, taskAssignmentId);
    
    // 2. Validate employee
    const employee = await validateEmployee(employeeId);
    
    // 3. Get and validate task details
    const task = await validateTask(taskAssignment.taskId);
    
    // 4. Set submission info
    const { isLate } = setSubmissionInfo(taskAssignment, task.deadline);
    
    // 5. Verify location void function if error throw error
    await verifyLocation(task.location, location, task.aroundDistanceMeter);
    
    // 6. Handle face verification if required
    if (taskAssignment.faceVerification) {
        return await handleFaceVerification(taskAssignment, employee, imageUrl, isLate, location);
    }

    
    // 7. If no face verification required, mark as verified
    taskAssignment.employeeLocation = location
    taskAssignment.status = taskAssignmentStatus.VERIFIED;
    taskAssignment.validateMethod = taskAssignmentValidateMethod.AUTO;
    
    await taskAssignment.save();
    return {
        method: taskAssignment.validateMethod, // AUTO
        taskAssignment: taskAssignment
    };
};