import mongoose from "mongoose";

const TaskStatus = {
  CREATED: "CREATED",
  ASSIGNED: "ASSIGNED",
  COMPLETED: "COMPLETED",
  // VERIFIED: "VERIFIED",
};


const taskSchema = new mongoose.Schema(
  {
    // employeeId: {
    //   type: mongoose.Types.ObjectId,
    //   ref: "employee",
    // },
    organizationId: {
      type: mongoose.Types.ObjectId,
      ref: "organization",
      required: true,
    },
    adminId: {
      type: mongoose.Types.ObjectId,
      ref: "admin",
      required: true,
    },
    title: {
      type: String,
      required: true,
      trim: true,
    },
    description: {
      type: String,
      trim: true,
    },
    dueDate: {
      type: Date,
      required: true,
    },
    // address: {
    //   type: mongoose.Types.ObjectId,
    //   ref: "address",
    // },
    location: {
      type: { type: String, default: "Point" },
      coordinates: [Number],  // [longitude, latitude]
      address : String
    },
    aroundDistanceMeter: {
      type : Number,
      default : 1000
    },
    status: {
      type: String,
      enum: Object.values(TaskStatus),
      default: TaskStatus.CREATED,
      // lowercase: true,
    },
  },
  {
    timestamps: true,
    toJSON : {
      virtuals : true,
      transform : function(doc, ret) {
        delete ret.__v
        delete ret.id
        return ret
      }
    }
  }
);

// Add indexes for frequently queried fields
// taskSchema.index({ employeeId: 1 });
// taskSchema.index({ organizationId: 1 });
// taskSchema.index({ status: 1 });

export const taskModel = mongoose.model("task", taskSchema);