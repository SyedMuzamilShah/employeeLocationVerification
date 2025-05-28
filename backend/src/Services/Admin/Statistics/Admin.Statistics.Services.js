import mongoose from "mongoose";
import { STATUS_CODES } from "../../../../constant.js";
import { taskModel } from "../../../Models/Task.Model.js";
import { ErrorResponse } from "../../../Utils/Error.js";
import { employeeModel, EmployeeRole } from "../../../Models/Employee.Model.js"

export const adminOrganizationTaskStatistics = async (dataObject) => {
    try {
        const { year, organizationId, adminId } = dataObject;
        // Convert organizationId to ObjectId if needed
        const orgId = mongoose.Types.ObjectId.isValid(organizationId) 
            ? new mongoose.Types.ObjectId(organizationId)
            : organizationId;
        const stats = await taskModel.aggregate([
            {
                $match: {
                    createdAt: {
                        $gte: new Date(`${year}-01-01T00:00:00.000Z`),
                        $lt: new Date(`${Number(year) + 1}-01-01T00:00:00.000Z`)
                    },
                    $or: [
                        // { organizationId: orgId }, // try as ObjectId
                        { organizationId: orgId } // try as string
                    ]

                }
            },
            {
                $group: {
                    _id: { $month: "$createdAt" },
                    count: { $sum: 1 }
                }
            },
            {
                $sort: { "_id": 1 }
            },
            {
                $project: {
                    _id: 0,
                    month: "$_id",
                    count: 1
                }
            }
        ]);

        // Format the response with all months (including those with 0 tasks)
        const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

        const formattedStats = monthNames.map((name, index) => {
            const monthData = stats.find(item => item.month === (index + 1));
            return {
                month: name,
                monthNumber: index + 1,  // Added month number for easier reference
                count: monthData ? monthData.count : 0
            };
        });

        return {
            year: Number(year),
            organizationId,
            adminId,
            monthlyStats: formattedStats
        };

    } catch (err) {
        // If it's already an ErrorResponse, rethrow it
        if (err instanceof ErrorResponse) {
            throw err;
        }
        throw new ErrorResponse(
            err.statusCode || STATUS_CODES.INTERNAL_SERVER_ERROR, 
            err.message || 'Server error'
        );
    }
};



export const adminGetEmployeeRoleStatistics = async (dataObject) => {
    try {
        const { organizationId } = dataObject

        // Get all possible roles
        const allRoles = Object.values(EmployeeRole);
        
        // Get counts for each role in the organization
        const roleCounts = await employeeModel.aggregate([
            {
                $match: {
                    organizationId: new mongoose.Types.ObjectId(organizationId)
                }
            },
            {
                $group: {
                    _id: "$role",
                    count: { $sum: 1 }
                }
            }
        ]);

        console.log(roleCounts)
        // Create a map for efficient lookup
        const roleCountMap = new Map(
            roleCounts.map(item => [item._id, item.count])
        );
        
        // Format response ensuring all roles are included
        const formattedStats = allRoles.map(role => ({
            role,
            count: roleCountMap.get(role) || 0
        }));
        
        // Calculate totals
        const totalEmployees = formattedStats.reduce((sum, {count}) => sum + count, 0);

        // Add percentages
        const statsWithPercentages = formattedStats.map(stat => ({
            ...stat,
            percentage: totalEmployees > 0 
                ? Math.round((stat.count / totalEmployees) * 100) 
                : 0
        }));

        return {
            organizationId,
            roles: statsWithPercentages,
            totalEmployees,
            // summary: {
            //     // Example custom groupings
            //     staff: formattedStats
            //         .filter(stat => stat.role !== EmployeeRole.GUEST)
            //         .reduce((sum, {count}) => sum + count, 0),
            //     nonStaff: formattedStats
            //         .find(stat => stat.role === EmployeeRole.GUEST)?.count || 0
            // }
        };

    } catch (err) {
        throw new ErrorResponse(
            err.statusCode || 500, 
            err.message || 'Failed to fetch role statistics'
        );
    }
};