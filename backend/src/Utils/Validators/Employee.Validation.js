import { body, query } from 'express-validator';
import { organizationModel } from '../../Models/Organization.Model.js';
import { EmployeeRole, EmployeeStatus } from '../../Models/Employee.Model.js';
import { isValidObjectId } from 'mongoose';

/**
 * Employee Registration Validator
 * Validates all fields required for employee registration
 */
export const validateEmployeeRegisterRoutes = [
    body('organizationId')
    .notEmpty()
    .withMessage('Organization id required')
    .isMongoId()
    .withMessage("Invalid Id"),

    body('userName')
        .trim()
        .notEmpty().withMessage('Username is required')
        .isLength({ min: 3, max: 30 }).withMessage('Username must be 3-30 characters')
        .matches(/^[a-z0-9_.]+$/).withMessage('Username can only contain lowercase letters, numbers, dots and underscores'),

    body('name')
        .optional()
        .trim()
        .isString().withMessage('Name must be a string')
        .isLength({ min: 2, max: 50 }).withMessage('Name must be 2-50 characters')
        .matches(/^[a-zA-Z\s]+$/).withMessage('Name can only contain letters and spaces'),

    body('email')
        .trim()
        .notEmpty().withMessage('Email is required')
        .isEmail().withMessage('Invalid email format')
        .normalizeEmail(),

    body('password')
        .notEmpty().withMessage('Password is required')
        .isLength({ min: 6 }).withMessage('Password must be at least 6 characters')
        // .matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/)
        .withMessage('Password must contain at least one uppercase, one lowercase, one number and one special character'),

    body('phoneNumber')
        .optional()
        .trim()
        .notEmpty().withMessage('Phone number cannot be empty if provided')
        .isLength({ min: 10, max: 15 }).withMessage('Phone number must be 10-15 characters')
        .matches(/^[+\d][\d\s-]+$/).withMessage('Invalid phone number format'),

    body('imageUrl')
        .optional()
        .isURL().withMessage('Invalid URL format for image')
        .matches(/\.(jpeg|jpg|png|gif)$/).withMessage('Image must be a valid image URL'),

    body('role')
        .notEmpty().withMessage('Role is required')
        .custom((value) => {
            const normalized = value.toUpperCase();
            if (!Object.values(EmployeeRole).includes(normalized)) {
                throw new Error(`Invalid status. Valid statuses are: ${Object.values(EmployeeRole).join(', ')}`);
            }
            return true;
        })
];


/**
 * Employee Login Validator
 * Validates credentials for employee login
 */
export const validateEmployeeLoginRoutes = [
    body('email')
        .trim()
        .notEmpty().withMessage('Email is required')
        .isEmail().withMessage('Invalid email format')
        .normalizeEmail(),

    body('password')
        .notEmpty().withMessage('Password is required')
        .isLength({ min: 6 }).withMessage('Password must be at least 6 characters')
];

/**
 * Employee Password Change Validator
 * Validates fields required for password change
 */
export const validateEmployeeChangePasswordRoutes = [
    body('currentPassword')
        .notEmpty().withMessage('Current password is required')
        .isLength({ min: 6 }).withMessage('Current password must be at least 6 characters'),

    body('newPassword')
        .notEmpty().withMessage('New password is required')
        .isLength({ min: 8 }).withMessage('New password must be at least 8 characters')
        .matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/)
        .withMessage('New password must contain at least one uppercase, one lowercase, one number and one special character')
        .custom((value, { req }) => value !== req.body.currentPassword)
        .withMessage('New password must be different from current password'),

    body('confirmPassword')
        .notEmpty().withMessage('Confirm password is required')
        .custom((value, { req }) => value === req.body.newPassword)
        .withMessage('Passwords do not match')
];

/**
 * Employee Forgot Password Validator
 * Validates email for password reset request
 */
export const validateEmployeeForgetPasswordRoutes = [
    body('email')
        .trim()
        .notEmpty().withMessage('Email is required')
        .isEmail().withMessage('Invalid email format')
        .normalizeEmail()
];

/**
 * Employee Status Change Validator
 * Validates fields for changing employee status
 */

export const validateEmployeeStatusChangeRoutes = [
    body('employeeId')
        .notEmpty().withMessage('Employee ID is required')
        .isMongoId().withMessage('Invalid Employee ID format'),

    body('status')
        .notEmpty().withMessage('Status is required')
        .custom((value) => {
            const normalized = value.toUpperCase();
            if (!Object.values(EmployeeStatus).includes(normalized)) {
                throw new Error(`Invalid status. Valid statuses are: ${Object.values(EmployeeStatus).join(', ')}`);
            }
            return true;
        }),
];

/**
 * Employee Get Validator
 * Validates employee ID for get operations
 */
export const validateEmployeeGetRoutes = [
    query('organizationId')
    .notEmpty().withMessage('organizationId is required')
    .isMongoId().withMessage('Invalid organizationId ID format')
];

/**
 * Employee Edit Validator
 * Validates fields for employee profile updates
 */
export const validateEmployeeEditRoutes = [
    body('employeeId')
        .notEmpty().withMessage('Employee ID is required')
        .bail()
        .isMongoId().withMessage('Invalid Employee ID format'),

    body('name')
        .optional()
        .trim()
        .isString().withMessage('Name must be a string')
        .isLength({ min: 2, max: 50 }).withMessage('Name must be 2-50 characters'),

    body('status')
        .optional()
        .trim()
        .custom((value) => {
            const normalized = value.toUpperCase();
            if (!Object.values(EmployeeStatus).includes(normalized)) {
                throw new Error(`Invalid status. Valid statuses are: ${Object.values(EmployeeStatus).join(', ')}`);
            }
            return true;
        }),
    body('role')
        .optional()
        .trim()
        .custom((value) => {
            const normalized = value.toUpperCase();
            if (!Object.values(EmployeeRole).includes(normalized)) {
                throw new Error(`Invalid status. Valid statuses are: ${Object.values(EmployeeRole).join(', ')}`);
            }
            return true;
        }),
    body("uploadNewImage")
        .optional()
        .isBoolean()
        .withMessage("UploadNewImage must be boolean value"),

    body('phoneNumber')
        .optional()
        .trim()
        .isLength({ min: 10, max: 15 }).withMessage('Phone number must be 10-15 characters'),
];

/**
 * Employee Delete Validator
 * Validates employee ID for deletion
 */
export const validateEmployeeDeleteRoutes = [
    body('employeeId')
        .notEmpty().withMessage('Employee ID is required')
        .isMongoId().withMessage('Invalid Employee ID format')
];

/**
 * Employee Picture Permission Validator
 * Validates employee ID for picture permission changes
 */
export const validateEmployeeAllowPictureRoutes = [
    body('employeeId')
        .notEmpty().withMessage('Employee ID is required')
        .isMongoId().withMessage('Invalid Employee ID format'),
];

export const validateEmployeeRejectPictureRoutes = [
    body('employeeId')
        .notEmpty().withMessage('Employee ID is required')
        .isMongoId().withMessage('Invalid Employee ID format'),
];

/**
 * Employee Request Action Validator
 * Validates fields for accepting/rejecting employee requests
 */

export const validateEmployeeRequestActionRoutes = [
    body('employeeId')
        .notEmpty().withMessage('Employee ID is required')
        .isMongoId().withMessage('Invalid Employee ID format'),

    body('action')
        .notEmpty().withMessage('Action is required')
        .isIn(['accept', 'reject']).withMessage('Action must be either "accept" or "reject"'),

    body('reason')
        .if(body('action').equals('reject'))
        .notEmpty().withMessage('Reason is required for rejection')
        .isString().withMessage('Reason must be a string')
];

/**
 * Employee Face Registration Validator
 * Validates face registration data
 */
export const validateEmployeeFaceRegisterRoutes = [
    body('employeeId')
        .notEmpty().withMessage('Employee ID is required')
        .isMongoId().withMessage('Invalid Employee ID format'),

    body('imageUrl')
        .notEmpty().withMessage('Image URL is required')
        .isURL().withMessage('Invalid URL format for image')
        .matches(/\.(jpeg|jpg|png|gif)$/).withMessage('Image must be a valid image URL')
]

/**
 * Employee Face Image Upload Validator
 * Validates face image upload data
 */

export const validateEmployeeImageUploadRoute = []

export const validateEmployeeRoleChangeRoute = [
    body("employeeId")
        .notEmpty().withMessage("Employee ID is required")
        .isMongoId().withMessage("Invalid Employee ID format"),
    body('role')
        .notEmpty().withMessage('Role is required')
        .custom((value) => {
            const normalized = value.toUpperCase();
            if (!Object.values(EmployeeRole).includes(normalized)) {
                throw new Error(`Invalid status. Valid statuses are: ${Object.values(EmployeeRole).join(', ')}`);
            }
            return true;
        })
]



export const validateEmployeeCompleteTaskRoute = [
    body("taskAssignmentId")
        .notEmpty()
        .withMessage("taskAssignmentId is required")
        .bail()
        .isMongoId()
        .withMessage("taskAssignmentId is not valid formate"),

    body("location")
        .notEmpty()
        .withMessage("Location is required")
        .bail()
        .custom((value) => {
            // console.log(value)
            if (typeof value !== 'object' || value.type !== 'Point' || !Array.isArray(value.coordinates)) {
                throw new Error("Location must be a GeoJSON Point with coordinates");
            }

            const [longitude, latitude] = value.coordinates;

            if (typeof longitude !== 'number' || typeof latitude !== 'number') {
                throw new Error("Coordinates must be numbers");
            }

            if (longitude < -180 || longitude > 180) {
                throw new Error("Longitude must be between -180 and 180");
            }

            if (latitude < -90 || latitude > 90) {
                throw new Error("Latitude must be between -90 and 90");
            }

            return true;
        })
]


export const validateEmployeeAssignTaskReadRoute = []