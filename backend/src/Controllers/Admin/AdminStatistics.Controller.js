import { STATUS_CODES } from "../../../constant.js";
import { controllerHandler } from "../../Utils/ControllerHandler.js";
import { SuccessResponse } from "../../Utils/Success.js"; 
import { adminGetEmployeeRoleStatistics, adminOrganizationTaskStatistics } from "../../Services/Admin/Statistics/Admin.Statistics.Services.js"
export const adminOrganizationTaskStatisticsController = controllerHandler (async (req, res) => {
    const adminId = req.user._id;
    const year = req.query.year || new Date().getFullYear();
    const dataObject = {adminId, ...req.body, ...req.query, year}
    
    const response = await adminOrganizationTaskStatistics(dataObject)
    
    return res.status(STATUS_CODES.OK).json(new SuccessResponse(STATUS_CODES.OK, 'Roll statictics fetch successfully', response))
})

export const adminGetEmployeeRoleStatisticsController = controllerHandler (async (req, res) => {
    const adminId = req.user?._id;
    const dataObject = {adminId, ...req.body, ...req.query}


    const response = await adminGetEmployeeRoleStatistics(dataObject)

    return res.status(STATUS_CODES.OK).json(new SuccessResponse(STATUS_CODES.OK, 'Employee Roles count', response))
})