import React, { useState } from "react";
import InputField from "../../components/InputField";
import Image from "../../components/Image";
import { useNavigate } from "react-router-dom";
import { useMutation } from "@tanstack/react-query";
import useAxiosSecure from "../../hooks/useAxiosSecure";
import toast from "react-hot-toast";

const ResetPassword = () => {
  const navigate = useNavigate();
  const axiosSecure = useAxiosSecure();

  const [email, setEmail] = useState("");

  const forgotPasswordMutation = useMutation({
    mutationFn: async (email) => {
      return await axiosSecure.post("/auth/forgot-password", { email });
    },
    onSuccess: () => {
      toast.success("OTP sent to your email");

      //   Save email temporarily
      sessionStorage.setItem("resetEmail", email);

      navigate("/auth/verify/otp");
    },
    onError: (error) => {
      toast.error(
        error.response?.data?.message || "Failed to send OTP"
      );
    },
  });

  const handleSubmit = (e) => {
    e.preventDefault();

    if (!email) {
      return toast.error("Email is required");
    }

    forgotPasswordMutation.mutate(email);
  };

  return (
    <main className="bg-white grid justify-center items-center overflow-y-auto py-10 md:px-11 px-15 rounded-3xl">
      <form
        onSubmit={handleSubmit}
        className="gap-5 flex flex-col items-center md:w-[450px] w-full"
      >
        <Image src="/authLogo.png" alt="logo" />

        <p className="text-[#00000]">Reset Password</p>
        <p className="text-[#333333] mb-5">
          Enter your email to receive an OTP
        </p>

        <InputField
          type="email"
          inputClass="rounded-lg"
          label="Email Address"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />

        <button
          type="submit"
          disabled={forgotPasswordMutation.isPending}
          className="bg-[#F6A62D] text-white w-full py-3 rounded-lg cursor-pointer mt-12"
        >
          {forgotPasswordMutation.isPending ? "Sending..." : "Send"}
        </button>
      </form>
    </main>
  );
};

export default ResetPassword;
