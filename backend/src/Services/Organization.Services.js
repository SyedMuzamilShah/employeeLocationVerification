import { STATUS_CODES } from "../../constant.js";
import { organizationModel } from "../Models/Organization.Model.js";
import { ErrorResponse } from "../Utils/Error.js";

/**
 * Checks if an organization is already registered
 * @param {Object} dataObject - Contains email and optional organizationNumber
 * @returns {Boolean} - True if organization exists, false otherwise
 */
export const organizationIsRegistered = async (dataObject) => {
    const { email, organizationNumber } = dataObject;

    try {
        // Build dynamic query
        const queryConditions = [{ email }];
        if (organizationNumber) {
            queryConditions.push({ uniqueName: organizationNumber });
        }

        const existingOrganization = await organizationModel.findOne({
            $or: queryConditions
        }).lean();

        return !!existingOrganization;

    } catch (err) {
        console.error("Organization check error:", err.message);
        throw err;
    }
};

/**
 * Creates a new organization
 * @param {Object} dataObject - Organization data including adminId
 * @returns {Object} - Created organization data
 */
export const organizationCreateServices = async (dataObject) => {
    const { adminId, name, phoneNumber, address, website, email, organizationNumber } = dataObject;

    try {
        // Check for existing organization
        const queryConditions = [{ email }];
        if (organizationNumber) {
            queryConditions.push({ uniqueName: organizationNumber });
        }

        const existingOrganization = await organizationModel.findOne({
            $or: queryConditions
        }).lean();


        if (existingOrganization) {
            throw new ErrorResponse(
                STATUS_CODES.CONFLICT,
                'Organization already registered with this email or ID'
            );
        }

        console.log("Tstingfasfad")
        console.log(adminId)
        // Create new organization
        const organization = await organizationModel.create({
            name,
            email,
            phoneNumber,
            website,
            location: address,
            createdBy: adminId,
        });

        // Remove version key from response
        const organizationResponse = organization.toObject();
        delete organizationResponse.__v;

        return organizationResponse;

    } catch (err) {
        console.error("Organization creation error:", err.message);
        throw err;
    }
};

/**
 * Deletes an organization
 * @param {Object} dataObject - Contains adminId and either id or organizationId
 * @returns {Object} - Success status and deleted organization
 */
export const deleteOrganization = async (dataObject) => {
    const { adminId, organizationId: id } = dataObject;

    try {
        // Build dynamic query
        const query = { createdBy: adminId };

        query._id = id;

        const organization = await organizationModel.findOneAndDelete(query);

        if (!organization) {
            throw new ErrorResponse(
                STATUS_CODES.NOT_FOUND,
                'No matching organization found for deletion'
            );
        }

        return {
            success: true,
            organization: organization.toObject()
        };
    } catch (error) {
        console.error("Organization deletion error:", error.message);
        throw error;
    }
};

/**
 * Retrieves organization(s) based on criteria
 * @param {Object} dataObject - Contains adminId and optional filters
 * @returns {Object} - Found organization(s)
 */
export const getAllOrganization = async (dataObject) => {
    const { adminId, organizationId } = dataObject;

    try {
        // Build dynamic query
        const query = { createdBy: adminId };
        if (organizationId){
            query._id = id;
        }

        const organizations = await organizationModel.find(query).lean();
        return { organizations };

    } catch (error) {
        if (error.name === 'CastError') {
            throw new ErrorResponse(
                STATUS_CODES.BAD_REQUEST,
                'Invalid organization identifier format'
            );
        }
        console.error("Organization fetch error:", error.message);
        throw new ErrorResponse(
            STATUS_CODES.INTERNAL_SERVER_ERROR,
            'Failed to retrieve organizations'
        );
    }
};

/**
 * Updates an organization
 * @param {Object} dataObject - Contains adminId, identifier, and update data
 * @returns {Object} - Updated organization
 */
export const updateOrganization = async (dataObject) => {
    const { adminId, organizationId, ...updateData } = dataObject;

    try {
        // Build dynamic query
        const query = { createdBy: adminId };

        query._id = organizationId;

        const organization = await organizationModel.findOneAndUpdate(
            query,
            updateData,
            { new: true, runValidators: true }
        ).lean();

        if (!organization) {
            throw new ErrorResponse(
                STATUS_CODES.NOT_FOUND,
                'No matching organization found for update'
            );
        }

        return { organization };

    } catch (error) {
        if (error.name === 'CastError') {
            throw new ErrorResponse(
                STATUS_CODES.BAD_REQUEST,
                'Invalid organization identifier format'
            );
        }
        console.error("Organization update error:", error.message);
        throw new ErrorResponse(
            STATUS_CODES.INTERNAL_SERVER_ERROR,
            'Failed to update organization'
        );
    }
};