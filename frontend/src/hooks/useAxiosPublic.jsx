import axios from "axios";
import { BASE_URL } from "../config/api";

const axiosPublic = axios.create({
    baseURL: BASE_URL,
    // withCredentials: true
});

const useAxiosPublic = () => {
    return axiosPublic;
};

export default useAxiosPublic;
