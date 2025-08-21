import React, { useState, useEffect } from "react";
import Password from "../../components/Password";
import Image from "../../components/Image";
import { useNavigate } from "react-router-dom";
import { useMutation } from "@tanstack/react-query";
import useAxiosPublic from "../../hooks/useAxiosPublic";
import toast from "react-hot-toast";

const NewPassword = () => {
  const navigate = useNavigate();
  const axiosPublic = useAxiosPublic();

  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");

  const email = sessionStorage.getItem("resetEmail");
  const resetToken = sessionStorage.getItem("resetToken");

  useEffect(() => {
    if (!email || !resetToken) {
      navigate("/auth/login");
    }
  }, [email, resetToken, navigate]);

  const resetPasswordMutation = useMutation({
    mutationFn: async () => {
      return await axiosPublic.post(
        "/auth/reset-password",
        {
          newPassword,
        },
        {
          headers: {
            Authorization: `Bearer ${resetToken}`, 
          },
        }
      );
    },
    onSuccess: () => {
      toast.success("Password reset successfully");

      sessionStorage.removeItem("resetEmail");
      sessionStorage.removeItem("resetToken");

      navigate("/auth/success");
    },
    onError: (error) => {
      toast.error(
        error.response?.data?.message || "Failed to reset password"
      );
    },
  });

  const handleSubmit = (e) => {
    e.preventDefault();

    if (!newPassword) {
      return toast.error("New password is required");
    }

    if (newPassword !== confirmPassword) {
      return toast.error("Passwords do not match");
    }

    resetPasswordMutation.mutate();
  };

  return (
    <main className="bg-white grid justify-center items-center py-10 md:px-11 px-12 rounded-3xl">
      <form
        onSubmit={handleSubmit}
        className="gap-5 flex flex-col items-center md:w-[450px] w-full"
      >
        <Image src="/authLogo.png" alt="logo" />

        <h3 className="font-medium text-[32px] text-[#333333]">
          Set a new Password
        </h3>

        <Password
          label="New Password"
          inputClass="rounded-lg"
          value={newPassword}
          onChange={(e) => setNewPassword(e.target.value)}
        />

        <Password
          label="Confirm Password"
          inputClass="rounded-lg"
          value={confirmPassword}
          onChange={(e) => setConfirmPassword(e.target.value)}
        />

        <button
          type="submit"
          disabled={resetPasswordMutation.isPending}
          className="bg-[#F6A62D] text-white w-full py-3 rounded-lg mt-12"
        >
          {resetPasswordMutation.isPending
            ? "Resetting..."
            : "Reset Password"}
        </button>
      </form>
    </main>
  );
};

export default NewPassword;
