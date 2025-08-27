import mongoose, { Schema, model } from "mongoose";

export const taskAssignmentStatus = {
    ASSIGNED: "ASSIGNED",
    SUBMITTED: "SUBMITTED",
    // INPROGRESS: "INPROGRESS",
    // COMPLETED: "COMPLETED",
    VERIFIED: "VERIFIED",
    REJECTED: "REJECTED"
};

export const taskAssignmentValidateMethod = {
    AUTO: "AUTO",
    MANAULLY: "MANAULLY"
}

const taskAssignmentSchema = new Schema(
    {
        taskId: {
            type: mongoose.Types.ObjectId,
            ref: 'task',
            required: true
        },
        faceVerification: {
            type: Boolean,
            default: true
        },
        confidence: {
            type: Number,
        },
        threshold: {
            type: Number,
        },
        validateMethod: {
            type: String,
            enum: Object.values(taskAssignmentValidateMethod)
        },
        submittedLate: {
            type: Boolean
        },
        submittedAt: {
            type: Date
        },
        employeeId: {
            type: mongoose.Types.ObjectId,
            ref: 'employee',
            required: true
        },
        assignedBy: {
            type: mongoose.Types.ObjectId,
            ref: 'Admin',
            required: true
        },
        pictureAllowed: {
            type: Boolean,
            default: false
        },
        employeeImage: {
            type: String
        },
        employeeLocation: {
            type: { type: String, default: "Point" },
            coordinates: [Number],  // [longitude, latitude]
            address: String
        },
        status: {
            type: String,
            enum: Object.values(taskAssignmentStatus),
            default: taskAssignmentStatus.ASSIGNED,
            // lowercase: true,
        },

        employeeCheckoutLocation: {
            type: { type: String, default: "Point" },
            coordinates: [Number],  // [longitude, latitude]
            address: String
        },
        checkIn: {
            type: Date
        },
        checkOut: {
            type: Date
        },
        deadline: {
            type: Date
        }
    }, {
    timestamps: true,
    toJSON: {
        virtuals: true,
        transform: function (doc, ret) {
            delete ret.__v;
            return ret;
        }
    },
}
)


export const taskAssignmentModel = model('taskAssignment', taskAssignmentSchema)