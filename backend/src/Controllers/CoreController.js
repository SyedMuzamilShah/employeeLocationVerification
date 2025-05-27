import { STATUS_CODES } from '../../constant.js';
import { getAddressSuggestions } from '../Utils/AddressSuggestion.js';
import { controllerHandler } from '../Utils/ControllerHandler.js'
import { SuccessResponse } from '../Utils/Success.js'
export const addressSuggestionsController = controllerHandler(async (req, res) => {
    const { address } = req.query;
    const response  = await getAddressSuggestions(address);
    console.log("response", response);
    res.status(STATUS_CODES.OK).json(
        new SuccessResponse(
            STATUS_CODES.OK,
            "Address suggestions fetched successfully",
            response
        ).toJson())
})
