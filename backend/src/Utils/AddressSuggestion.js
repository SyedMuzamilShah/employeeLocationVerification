import axios from "axios";

const ApiKey = process.env.GeoApiKey;

export const getAddressSuggestions = async (input) => {
    console.log(process.env.GeoApiKey)
    const url = `https://api.geoapify.com/v1/geocode/autocomplete?text=${input}&apiKey=${process.env.GeoApiKey}`;

    try {
        const response = await axios.get(url);
        const simplified = response.data.features.map((feature) => {
            const props = feature.properties;
            const coords = feature.geometry.coordinates;

            return {
                properties: {
                    name: props.formatted || `${props.city || ''}, ${props.state || ''}, ${props.country || ''}`,
                    formatted: props.formatted || '',
                    city: props.city || '',
                    state: props.state || '',
                    country: props.country || ''
                },
                coordinates: {
                    latitude: coords[1],
                    longitude: coords[0]
                }
            };
        });
        return simplified
        return [
            {
                "properties": {
                    "name": "Zarghoon Road, Quetta, Balochistan, Pakistan",
                    "formatted": "Zarghoon Road, Quetta, Balochistan, Pakistan",
                    "city": "Quetta",
                    "state": "Balochistan",
                    "country": "Pakistan"
                },
                "coordinates": {
                    "latitude": 30.1798,
                    "longitude": 66.9750
                }
            }
        ]


        // return response.data.features.map((feature)=> {
        //     return {
        //         name: feature.properties.formatted,
        //         latitude: feature.geometry.coordinates[1],
        //         longitude: feature.geometry.coordinates[0],
        //         city: feature.properties.city,
        //         state: feature.properties.state,
        //         country: feature.properties.country,
        //     }
        // });
    } catch (error) {
        console.error("Error fetching address suggestions:", error);
        throw error;
    }
}