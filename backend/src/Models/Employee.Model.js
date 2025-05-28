import mongoose, { Schema, model } from "mongoose";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { nanoid } from "nanoid";

// Define enums as frozen objects to prevent modification
const EmployeeStatus = Object.freeze({
  VERIFIED: "VERIFIED",
  PENDING: "PENDING",
  REJECTED: "REJECTED",
  BLOCKED: "BLOCKED",
});

const EmployeeRole = Object.freeze({
  GUEST: "GUEST",
  SERVANT: "SERVANT",
  MANAGER: "MANAGER",
  EMPLOYEE: "EMPLOYEE"
});

// Constants for token expiration
const TOKEN_EXPIRATION = {
  ACCESS: process.env.ACCESS_TOKEN_SECRET_TIME || '7hr',
  REFRESH: process.env.REFRESH_TOKEN_SECRET_TIME || '7d'
};

const employeeSchema = new Schema(
  {
    employeeId: {
      type: String,
      default: () => `EMP-${nanoid(6).toUpperCase()}`,
      unique: true,
      immutable: true,  // Prevent modification after creation
      index: true
    },
    organizationId: {
      type: mongoose.Types.ObjectId,
      ref: "organization",
      required: true,
      index: true
    },
    userName: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
      minlength: 3,
      maxlength: 30,
      match: [/^[a-z0-9_.]+$/, 'Username can only contain lowercase letters, numbers, dots and underscores']
    },
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
      match: [/^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/, 'Please fill a valid email address']
    },
    name: {
      type: String,
      trim: true,
      maxlength: 50
    },
    isEmailVerified: { 
      type: Boolean, 
      default: false 
    },
    imageUrl: {
      type: String,
      validate: {
        validator: function(v) {
          return /^(https?:\/\/)(localhost(:\d+)?|[\da-z.-]+\.[a-z.]{2,6})([/\w .-]*)*\/?$/.test(v);
        },
        message: props => `${props.value} is not a valid URL!`
      }
    },
    password: {
      type: String,
      select: false,
      minlength: 6,
      // validate: {
      //   validator: function(v) {
      //     return /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/.test(v);
      //   },
      //   message: props => 'Password must contain at least one uppercase, one lowercase, one number and one special character'
      // }
    },
    biometricToken: {
      type: String,
      select: false
    },
    phoneNumber: {
      type: String,
      trim: true,
      validate: {
        validator: function(v) {
          return /^[+]?[(]?[0-9]{1,4}[)]?[-\s./0-9]*$/.test(v);
        },
        message: props => `${props.value} is not a valid phone number!`
      }
    },
    role: {
      type: String,
      enum: Object.values(EmployeeRole),
      required: true,
      default: EmployeeRole.EMPLOYEE
    },
    status: {
      type: String,
      enum: Object.values(EmployeeStatus),
      default: EmployeeStatus.PENDING
    },
    imageAcceptedForToken: {
      type: Boolean,
      default: false,
      select: false
    },
    fcmToken: {
      type: String,
      select: false
    },
    socketId: {
      type: String,
      select: false
    },
    refreshToken: {
      type: String,
    },
    uploadNewImage: {
      type: Boolean,
      default: false,
    },
    emailVerificationToken: { 
      type: String, 
      select: false 
    },
    // lastLogin: {
    //   type: Date,
    //   select: false
    // },
    // loginAttempts: {
    //   type: Number,
    //   default: 0,
    //   select: false
    // },
    // lockUntil: {
    //   type: Date,
    //   select: false
    // }
  },
  {
    timestamps: true,
    toJSON: {
      virtuals: true,
      transform: function(doc, ret) {
        delete ret.password;
        delete ret.__v;
        delete ret.refreshToken;
        return ret;
      }
    },
    // toObject: {
    //   virtuals: true,
    //   transform: function(doc, ret) {
    //     delete ret.password;
    //     delete ret.__v;
    //     return ret;
    //   }
    // }
  }
);

// Indexes for better query performance
// employeeSchema.index({ email: 1 });
// employeeSchema.index({ organizationId: 1, status: 1 });

// Password hashing middleware
employeeSchema.pre("save", async function(next) {
  if (!this.isModified("password")) return next();

  try {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    return next();
  } catch (err) {
    return next(err);
  }
});

// Password validation
employeeSchema.methods.isPasswordValid = async function(password) {
  try {
    if (this.lockUntil && this.lockUntil > Date.now()) {
      throw new Error('Account is temporarily locked due to too many failed attempts');
    }

    const isMatch = await bcrypt.compare(password, this.password);
    
    if (isMatch) {
      // await this.resetLoginAttempts();
      return true;
    } else {
      // await this.incrementLoginAttempts();
      return false;
    }
  } catch (err) {
    throw err;
  }
};

// Token generation methods
employeeSchema.methods.generateAccessToken = function() {
  return jwt.sign(
    { 
      _id: this._id,
      role: this.role,
      organizationId: this.organizationId
    },
    process.env.ACCESS_TOKEN_SECRET_KEY,
    { expiresIn: TOKEN_EXPIRATION.ACCESS }
  );
};

employeeSchema.methods.generateRefreshToken = function() {
  const token = jwt.sign(
    { 
      _id: this._id,
      tokenVersion: this.tokenVersion || 0
    },
    process.env.REFRESH_TOKEN_SECRET_KEY,
    { expiresIn: TOKEN_EXPIRATION.REFRESH }
  );
  
  this.refreshToken = token;
  return token;
};

// // Account locking for too many failed attempts
// employeeSchema.methods.incrementLoginAttempts = async function() {
//   if (this.lockUntil && this.lockUntil > Date.now()) return;

//   const updates = { $inc: { loginAttempts: 1 } };
  
//   if (this.loginAttempts + 1 >= 5) {
//     updates.$set = { 
//       lockUntil: Date.now() + 30 * 60 * 1000 // Lock for 30 minutes
//     };
//   }

//   return this.updateOne(updates);
// };

// employeeSchema.methods.resetLoginAttempts = async function() {
//   return this.updateOne({
//     $set: { loginAttempts: 0 },
//     $unset: { lockUntil: 1 }
//   });
// };


// // Virtual for full employee name
// employeeSchema.virtual('fullName').get(function() {
//   return this.name || this.userName;
// });

// // Static method for finding by token
// employeeSchema.statics.findByToken = async function(token) {
//   try {
//     const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET_KEY);
//     return this.findOne({ _id: decoded._id, 'tokens.token': token });
//   } catch (err) {
//     throw err;
//   }
// };

export const employeeModel = model("Employee", employeeSchema);

export { EmployeeStatus, EmployeeRole };