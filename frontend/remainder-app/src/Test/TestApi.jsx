import { useState, useEffect, use } from "react"
import apiClient from '../api/axios.js'

function TestApi() {

    const [weatherforecast, setWeatherforecast] = useState([]);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const response = await apiClient.get('/WeatherForecast');
                console.log(response.data);
                setWeatherforecast(response.data);
            } catch (error) {
                console.error('Error fetching users:', error);
            }
        };
        fetchData();
    }, []);
    return (
        <div>
            <h1>Weather Forecast</h1>
            <ul>
                {weatherforecast.map((forecast, index) => (
                    <li key={index}>
                        <strong>Date:</strong> {forecast.date} | <strong>TemperatureC:</strong> {forecast.temperatureC} | <strong>TemperatureF:</strong> {forecast.temperatureF} | <strong>Summary:</strong> {forecast.summary}
                    </li>
                ))}
            </ul>
        </div>
    )
}

export default TestApi