import { body, query } from 'express-validator';

export const validateOrganizationRoutes = [
    body('name')
    .notEmpty().withMessage('Name is Reqired'),
    body('email')
    .notEmpty().withMessage('email is Reqired'),
    body('phoneNumber')
    .notEmpty().withMessage('phone is Reqired'),
    body('website')
    .notEmpty().withMessage('website is Reqired'),
    body('address')
    .notEmpty().withMessage('address is Reqired'),
];

export const validateOrganizationEditRoute = [
    query('organizationId')
    .notEmpty()
    .withMessage('Organization id required')
    .isMongoId()
    .withMessage("Invalid Id"),
]

export const validateOrganizationGetRoute = [
    query('organizationId')
    .optional()
    .notEmpty()
    .withMessage('Organization id required')
    .isMongoId()
    .withMessage("Invalid Id"),
]
export const validateOrganizationDeleteRoute = [
    query('organizationId')
    .notEmpty()
    .withMessage('Organization id required')
    .isMongoId()
    .withMessage("Invalid Id"),
    
]