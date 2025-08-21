import React, { useRef, useState, useEffect } from "react";
import Image from "../../components/Image";
import { useNavigate } from "react-router-dom";
import { useMutation } from "@tanstack/react-query";
import useAxiosPublic from "../../hooks/useAxiosPublic";
import toast from "react-hot-toast";
import Cookies from "js-cookie";

const OTP = () => {
  const inputs = useRef([]);
  const navigate = useNavigate();
  const axiosPublic = useAxiosPublic();

  const [otp, setOtp] = useState(["", "", "", "", "", ""]);

  const email = sessionStorage.getItem("resetEmail");

  useEffect(() => {
    if (!email) {
      navigate("/auth/login");
    }
  }, [email, navigate]);

 const verifyOtpMutation = useMutation({
  mutationFn: async () => {
    const fullOtp = otp.join("");

    return await axiosPublic.post(
      "/auth/verify-forgot-password-otp",
      {
        email,
        otp: fullOtp,
      }
    );
  },
  onSuccess: (res) => {
    const resetToken = res.data.data.resetToken;

    sessionStorage.setItem("resetToken", resetToken);

    toast.success("OTP verified successfully");
    navigate("/auth/new/password");
  },
  onError: (error) => {
    toast.error(
      error.response?.data?.message || "Invalid OTP"
    );
  },
});


  const handleChange = (e, index) => {
    const value = e.target.value.replace(/[^0-9]/g, "");

    const newOtp = [...otp];
    newOtp[index] = value;
    setOtp(newOtp);

    if (value && index < 5) {
      inputs.current[index + 1].focus();
    }
  };

  const handleKeyDown = (e, index) => {
    if (e.key === "Backspace" && !otp[index] && index > 0) {
      inputs.current[index - 1].focus();
    }
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    const fullOtp = otp.join("");

    if (fullOtp.length !== 6) {
      return toast.error("Please enter full 6 digit OTP");
    }

    verifyOtpMutation.mutate();
  };

  return (
    <main className="bg-white grid justify-center items-center py-10 md:px-11 px-12 rounded-3xl">
      <form
        onSubmit={handleSubmit}
        className="gap-5 flex flex-col items-center md:w-[450px] w-full"
      >
        <Image src="/authLogo.png" alt="logo" />

        <h3 className="font-medium text-[32px] text-[#333333]">
          Enter your OTP
        </h3>

        <div className="flex gap-4 justify-center my-10">
          {[...Array(6)].map((_, i) => (
            <input
              key={i}
              type="text"
              maxLength={1}
              ref={(el) => (inputs.current[i] = el)}
              onChange={(e) => handleChange(e, i)}
              onKeyDown={(e) => handleKeyDown(e, i)}
              value={otp[i]}
              className="w-[47px] h-[49px] border border-[#F6A62D] rounded-[10px] text-center text-xl font-bold text-[#F6A62D] outline-none"
            />
          ))}
        </div>

        <button
          type="submit"
          disabled={verifyOtpMutation.isPending}
          className="bg-[#F6A62D] text-white w-full py-3 rounded-lg mt-12"
        >
          {verifyOtpMutation.isPending ? "Verifying..." : "Verify"}
        </button>
      </form>
    </main>
  );
};

export default OTP;
