import { STATUS_CODES } from "../../../constant.js";
import { ErrorResponse } from "../../Utils/Error.js";
import { validationResult } from "express-validator";
import { SuccessResponse } from "../../Utils/Success.js";
import { decodeAddress } from "../../Utils/AddressConverter.js";
import { controllerHandler } from "../../Utils/ControllerHandler.js";
import { 
    deleteOrganization, 
    getAllOrganization, 
    organizationCreateServices, 
    organizationIsRegistered, 
    updateOrganization
} from "../../Services/Organization.Services.js";

/**
 * Registers a new organization
 */
export const adminCreateOrganization = controllerHandler(async (req, res) => {
    const adminId = req.user._id;

    const dataObject = { adminId, ...req.body };
    
    try {
        // Check if organization exists
        const isRegistered = await organizationIsRegistered(dataObject);
        if (isRegistered) {
            throw new ErrorResponse(
                STATUS_CODES.CONFLICT,
                'An organization with that email or ID is already registered'
            );
        }

        // Process address - currently mocked
        // const address = req.body.address;
        // const response = await decodeAddress(address);
        // if (response.error) {
        //     throw new ErrorResponse(
        //         STATUS_CODES.BAD_REQUEST, 
        //         response.error
        //     );
        // }

        // // Create organization (using mocked address ID)
        // dataObject.address = "67da450365ab8a16a9ef9649"; // TODO: Replace with real address service


        const organization = await organizationCreateServices(dataObject);

        return res.status(STATUS_CODES.CREATED).json(
            new SuccessResponse(
                STATUS_CODES.CREATED,
                'Organization created successfully', 
                { organization }
            ).toJson()
        );
        
    } catch (err) {
        console.error("Organization registration error:", err.message);
        throw err;
    }
});

/**
 * Retrieves organization(s) for admin
 */
export const adminGetAllOrganization = controllerHandler(async (req, res) => {
    const adminId = req.user._id;

    const dataObject = { adminId, ...req.query };
    
    try {
        const { organizations } = await getAllOrganization(dataObject);
        return res.status(STATUS_CODES.OK).json(
            new SuccessResponse(
                STATUS_CODES.OK,
                'Organizations retrieved successfully', 
                { organizations }
            ).toJson()
        );
        
    } catch (err) {
        console.error("Organization fetch error:", err.message);
        throw err;
    }
});

/**
 * Deletes an admin's organization
 */
export const adminDeleteOrganization = controllerHandler(async (req, res) => {
    const adminId = req.user._id;

    const dataObject = { adminId, ...req.query };
    
    try {
        const { organization } = await deleteOrganization(dataObject);
        
        return res.status(STATUS_CODES.NO_CONTENT).json(
            new SuccessResponse(
                STATUS_CODES.NO_CONTENT,
                'Organization deleted successfully', 
                { organization }
            ).toJson()
        );
        
    } catch (err) {
        console.error("Organization deletion error:", err.message);
        throw err;
    }
});

/**
 * edit an admin's organization
 */
export const adminEditOrganizationController = controllerHandler(async (req, res) => {
    const adminId = req.user._id;


    const dataObject = { adminId, ...req.query };
    
    try {
        const { organization } = await updateOrganization(dataObject);
        
        return res.status(STATUS_CODES.NO_CONTENT).json(
            new SuccessResponse(
                STATUS_CODES.NO_CONTENT,
                'Organization deleted successfully', 
                { organization }
            ).toJson()
        );
        
    } catch (err) {
        console.error("Organization deletion error:", err.message);
        throw err;
    }
});