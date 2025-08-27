import { body } from 'express-validator';

export const validateAdminRegisterRoutes = [
    body('name')
    .optional().trim().notEmpty().withMessage('Name is required')
    .isLength({ min: 3 }).withMessage('Name must be at least 3 characters'),
    
    body('userName')
    .notEmpty().withMessage('Username is required')
    .isLength({ min: 3 }).withMessage('Username must be at least 3 characters'),
    
    body('email')
        .trim()
        .notEmpty().withMessage("Email is required")
        .isEmail().withMessage('Invalid email'),
        
    body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),

    // body('phoneNumber')
    // .optional().trim().notEmpty().withMessage('Phone number field must not be empty')
    // .isLength({min: 10, max: 13}).withMessage('Phone number must be between 10 to 13 characters'),
];

export const validateAdminLoginRoutes = [
    body('userName').optional().trim().notEmpty().withMessage('Username is required'),

    body('email')
        .trim()
        .notEmpty().withMessage("Email is required")
        .isEmail().withMessage('Invalid email'),

    body('password')
        .notEmpty().withMessage("password is required")
        .isLength({ min: 6 })
        .withMessage('Password must be at least 6 characters'),
];

export const validateAdminChangePasswordRoutes = [
    body("oldPassword")
    .notEmpty()
    .withMessage("old password is required"),
    body("newPassword")
    .notEmpty()
    .withMessage("old password is required"),
];

export const validateAdminRefreshTokenRoutes = [
    body('refreshToken').notEmpty().withMessage('refreshToken'),
];

export const validateAdminForgetPasswordRoutes = [
    body('email').isEmail().withMessage('Invalid email'),
];