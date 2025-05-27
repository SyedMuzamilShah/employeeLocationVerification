import { body, query } from 'express-validator';
import { EmployeeRole, EmployeeStatus } from '../../../Models/Employee.Model.js';

/**
 * Employee Registration Validator
 * Validates all fields required for employee registration
 */
export const validateEmployeeRegisterRoutesForEmployee = [
    body('organizationId')
    .notEmpty()
    .withMessage('Organization id required'),

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
        .optional()
        .notEmpty().withMessage('Role is required')
        .custom((value) => {
            const normalized = value.toUpperCase();
            if (!Object.values(EmployeeRole).includes(normalized)) {
                throw new Error(`Invalid status. Valid statuses are: ${Object.values(EmployeeRole).join(', ')}`);
            }
            return true;
        })
];