import { body, query } from 'express-validator';

export const validateOrganizationRoutes = [
    body('name')
        .notEmpty().withMessage('Name is Reqired'),
    body('email')
        .notEmpty().withMessage('email is Reqired')
        .isEmail()
        .withMessage("Email must be valid email"),

    body('phoneNumber')
        .notEmpty().withMessage('Phone number is required')
        .custom((value) => {
            // Remove spaces
            const phone = value.replace(/\s+/g, '');

            // Check if it starts with +92
            if (!phone.startsWith('+92')) {
                throw new Error('Phone number must start with +92');
            }

            // Remove +92 and check remaining length & digits
            const localPart = phone.slice(3);
            if (!/^\d+$/.test(localPart)) {
                throw new Error('Phone number must contain only digits after +92');
            }

            if (localPart.length !== 10) {
                throw new Error('Phone number must be 10 digits after +92');
            }

            return true;
        }),

    body('website')
    .optional()
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