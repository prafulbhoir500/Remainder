import axios from 'axios';
import { AppConfig } from '../config/index.js';

const apiClient = axios.create({
    baseURL: AppConfig.api.baseUrl,
    timeout: 10000, // 10 seconds
    headers: {
        'Content-Type': 'application/json',
    },
    //withCredentials: true, // optional: if you're handling cookies
});

export default apiClient;