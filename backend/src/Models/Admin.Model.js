import mongoose, { Schema, model } from "mongoose";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
const officerSchema = new Schema(
  {
    name: {
      type: String,
    },
    userName : {
      type: String,
      required: true,
      unique: true,
    },
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
    },

    password: {
      type: String,
      required: true,
      select: false
    },
    // phoneNumber: {
    //   type: String,
    // },

    organizationId: {
      type: mongoose.Types.ObjectId,
      ref: "organization",
      // required: true,
    },
    isEmailVerified: { type: Boolean, default: false },
    emailVerificationToken: { type: String },
    emailVerificationExpires: { type: Date },
    emailVerificationToken: {type: String},
    role: {
      type: String,
    },
    refreshToken: {
      type: String,
    },
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
  }
);


// Pre save hook to hash the password before saving the officer Schema Object
officerSchema.pre("save", async function (next) {

  // If the password is not modified, then skip this step
  if (!this.isModified("password")) return next();

  // Hash the password
  this.password = await bcrypt.hash(this.password, 10);

  // Move to the next middleware
  next();
});

// Method to check if the password is valid
officerSchema.methods.isPasswordValid = async function (password) {

  // Compare the password with the hashed password
  return await bcrypt.compare(password, this.password);
};

// Method to generate the access token
officerSchema.methods.generateAccessToken = function () {

  // use the user schema object _id to generate the access token with the secret key and the expiry time
  return jwt.sign({ _id: this._id }, process.env.ACCESS_TOKEN_SECRET_KEY, {
    expiresIn: process.env.ACCESS_TOKEN_SECRET_TIME,
  });
};

// Method to generate the refresh token
officerSchema.methods.generateRefreshToken = function () {

  // use the user schema object _id to generate the refresh token with the secret key and the expiry time
  return jwt.sign({ _id: this._id }, process.env.REFRESH_TOKEN_SECRET_KEY, {
    expiresIn: process.env.REFRESH_TOKEN_SECRET_TIME,
  });
};

// Export the officer model
export const adminModel = model("admin", officerSchema);
