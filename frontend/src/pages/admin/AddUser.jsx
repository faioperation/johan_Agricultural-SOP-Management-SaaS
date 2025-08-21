import React, { useState, useEffect } from "react";
import InputField from "../../components/InputField";
import { FaArrowLeft } from "react-icons/fa6";
import { useNavigate, useParams, useLocation } from "react-router-dom";
import Breadcrumb from "../../components/Bredcumb";
import Dropdown from "../../components/Dropdown";
import Password from "../../components/Password";
import { useMutation, useQuery } from "@tanstack/react-query";
import useAxiosSecure from "../../hooks/useAxiosSecure";
import toast from "react-hot-toast";
import { HiH3 } from "react-icons/hi2";

const AddUser = () => {
  const navigate = useNavigate();
  const { id } = useParams(); //   check edit mode
  const location = useLocation();
  const initialUserData = location.state?.user;
  const axiosSecure = useAxiosSecure();

  const isEdit = !!id;

  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [role, setRole] = useState("");
  const [password, setPassword] = useState("");

  //   Fetch user if edit mode
  const { data: userData, isLoading } = useQuery({
    queryKey: ["userDetails", id],
    queryFn: async () => {
      const res = await axiosSecure.get(`/farm-admin/users/${id}`);
      return res.data.data;
    },
    enabled: isEdit,
    initialData: initialUserData,
  });

  //   Prefill form
  useEffect(() => {
    if (userData) {
      setName(userData.name);
      setEmail(userData.email);
      setRole(userData.role);
    }
  }, [userData]);

  //   Create User
  const createUserMutation = useMutation({
    mutationFn: async (userData) => {
      return await axiosSecure.post("/farm-admin/users", userData);
    },
    onSuccess: () => {
      toast.success("User created successfully");
      navigate("/admin/user/management");
    },
    onError: (error) => {
      toast.error(error.response?.data?.message || "Failed to create user");
    },
  });

  //   Update User
  const updateUserMutation = useMutation({
    mutationFn: async (userData) => {
      return await axiosSecure.patch(`/farm-admin/users/${id}`, userData);
    },
    onSuccess: () => {
      toast.success("User updated successfully");
      navigate("/admin/user/management");
    },
    onError: (error) => {
      toast.error(error.response?.data?.message || "Failed to update user");
    },
  });

  const handleSubmit = () => {
    if (!name || !email || !role) {
      return toast.error("Name, Email and Role are required");
    }

    if (!isEdit && !password) {
      return toast.error("Password is required");
    }

    const payload = {
      name,
      email,
      role,
    };

    if (password) {
      payload.password = password;
    }

    if (isEdit) {
      updateUserMutation.mutate(payload);
    } else {
      createUserMutation.mutate({
        ...payload,
        role: role.toUpperCase(),
      });
    }
  };

  if (isEdit && isLoading) {
    return <div className="p-10 text-[#0A0A0A]">Loading user...</div>;
  }

  return (
    <div>
      <div
        onClick={() => navigate(-1)}
        className="flex items-center gap-2 cursor-pointer"
      >
        <FaArrowLeft className=" text-[#4A5565]" />
        <p className="text-[#4A5565]">Back to User List</p>
      </div>

      <div className="mt-4">
        <div>
          {isEdit ? (
            <h3 className="text-[#0A0A0A] text-3xl whitespace-nowrap">
              Edit {userData?.name}
            </h3>
          ) : (
            <Breadcrumb />
          )}
        </div>
        <p className="text-[#4A5565] text-sm md:text-base mt-1.5">
          {isEdit
            ? "Update employee or manager account"
            : "Create a new employee or manager account"}
        </p>
      </div>

      <div className="bg-white p-6 rounded-lg border-2 border-[#E5E7EB] flex flex-col gap-6 mt-6">
        <InputField
          type="text"
          inputClass="rounded-lg"
          label="Full Name"
          value={name}
          onChange={(e) => setName(e.target.value)}
        />

        <InputField
          type="email"
          inputClass="rounded-lg"
          label="Email Address"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />

        <Password
          label="Password"
          inputClass="rounded-lg"
          placeholder={isEdit ? "Can keep current password" : "Enter password"}
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
        
        <Dropdown
          label="Role"
          placeholder="Select Role"
          options={["MANAGER", "EMPLOYEE"]}
          onSelect={(value) => setRole(value)}
          selected={role}
        />

        <button
          onClick={handleSubmit}
          disabled={
            createUserMutation.isPending || updateUserMutation.isPending
          }
          className="bg-[#F6A62D] text-white px-4 py-2 rounded-md hover:bg-[#e5942b] cursor-pointer mt-6"
        >
          {createUserMutation.isPending || updateUserMutation.isPending
            ? "Processing..."
            : isEdit
              ? "Update User"
              : "Create User"}
        </button>
      </div>
    </div>
  );
};

export default AddUser;
