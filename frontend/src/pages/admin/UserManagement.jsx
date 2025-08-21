import React, { useState } from "react";
import Breadcrumb from "../../components/Bredcumb";
import { FaPlus } from "react-icons/fa6";
import { FaSearch } from "react-icons/fa";
import Table from "../../components/Table";
import { Link } from "react-router-dom";
import { FiEdit, FiUserCheck, FiUserX } from "react-icons/fi";
import { RiDeleteBinLine } from "react-icons/ri";
import Pagination from "../../components/Pagination";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import useAxiosSecure from "../../hooks/useAxiosSecure";
import toast from "react-hot-toast";

const UserManagement = () => {
  const axiosSecure = useAxiosSecure();
  const queryClient = useQueryClient();
  const [deleteUserId, setDeleteUserId] = useState(null);


  const [search, setSearch] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 10;

  //   GET USERS
  const { data: users = [], isLoading } = useQuery({
    queryKey: ["farmUsers"],
    queryFn: async () => {
      const res = await axiosSecure.get("/farm-admin/users");
      return res.data.data.users || [];
    },
  });

  //   DELETE USER
 const deleteMutation = useMutation({
  mutationFn: async (id) => {
    return await axiosSecure.delete(`/farm-admin/users/${id}`);
  },
  onSuccess: () => {
    toast.success("User deleted successfully");
    queryClient.invalidateQueries(["farmUsers"]);
    setDeleteUserId(null); //   modal close
  },
  onError: () => {
    toast.error("Failed to delete user");
  },
});


  //   STATUS TOGGLE
  const statusMutation = useMutation({
    mutationFn: async ({ id, currentStatus }) => {
      const newStatus = currentStatus === "ACTIVE" ? "INACTIVE" : "ACTIVE";

      return await axiosSecure.patch(`/farm-admin/users/${id}/status`, {
        status: newStatus,
      });
    },
    onSuccess: () => {
      toast.success("User status updated");
      queryClient.invalidateQueries(["farmUsers"]);
    },
    onError: () => {
      toast.error("Failed to update status");
    },
  });

  //    FILTER
  const filteredData = users.filter(
    (u) =>
      u.name?.toLowerCase().includes(search.toLowerCase()) ||
      u.email?.toLowerCase().includes(search.toLowerCase()),
  );

  //   Pagination
  const totalPages = Math.ceil(filteredData.length / itemsPerPage);
  const startIndex = (currentPage - 1) * itemsPerPage;
  const paginatedData = filteredData.slice(
    startIndex,
    startIndex + itemsPerPage,
  );

  const TableHeads = [
    { Title: "Name", key: "name", width: "15%" },
    { Title: "Email", key: "email", width: "15%" },
    {
      Title: "Role",
      key: "role",
      width: "15%",
      render: (row) => (
        <span
          className={`px-2 py-1 rounded text-sm ${
            row.role === "EMPLOYEE"
              ? "bg-[#DBEAFE] text-[#1447E6]"
              : row.role === "MANAGER"
                ? "bg-[#F3E8FF] text-[#8200DB]"
                : " bg-[#DCFCE7] text-[#008236]"
          }`}
        >
          {row.role}
        </span>
      ),
    },
    {
      Title: "Status",
      key: "status",
      width: "15%",
      render: (row) => (
        <span
          className={`px-2 py-1 rounded text-sm ${
            row.status === "ACTIVE"
              ? "bg-green-100 text-green-600"
              : "bg-red-100 text-red-600"
          }`}
        >
          {row.status}
        </span>
      ),
    },
    {
      Title: "Join Date",
      key: "createdAt",
      width: "15%",
      render: (row) => new Date(row.createdAt).toISOString().split("T")[0],
    },
    {
      Title: "Actions",
      key: "actions",
      width: "15%",
      render: (row) => (
        <div className="flex items-center justify-center gap-4">
          <Link to={`/admin/user/management/edit/user/${row.id}`} state={{ user: row }}>
            <button className="text-blue-600 hover:text-blue-800 cursor-pointer">
              <FiEdit />
            </button>
          </Link>

          <button
            className={`cursor-pointer ${
              row.status === "ACTIVE" ? "text-[#F54900]" : "text-[#00A63E]"
            }`}
            onClick={() =>
              statusMutation.mutate({
                id: row.id,
                currentStatus: row.status,
              })
            }
          >
            {row.status === "ACTIVE" ? <FiUserX /> : <FiUserCheck />}
          </button>

          <button
            className="text-[#E7000B] cursor-pointer"
        onClick={() => setDeleteUserId(row.id)}
          >
            <RiDeleteBinLine />
          </button>
        </div>
      ),
    },
  ];

  if (isLoading) {
    return <div className="p-10">Loading users...</div>;
  }

  return (
    <div>
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <Breadcrumb />
          <p className="text-[#4A5565] text-sm md:text-base mt-1.5">
            Manage employees and managers
          </p>
        </div>

        <Link to="/admin/user/management/add/user">
          <button className="bg-[#F6A62D] text-white px-4 py-2 rounded-md flex items-center gap-2 hover:bg-[#e5942b] cursor-pointer">
            <FaPlus />
            Add User
          </button>
        </Link>
      </div>

      {/* Search */}
      <div className="relative mt-6">
        <FaSearch className="absolute top-1/2 -translate-y-1/2 left-3 text-[#99A1AF] " />
        <input
          type="text"
          placeholder="Search users..."
          value={search}
          onChange={(e) => {
            setSearch(e.target.value);
            setCurrentPage(1);
          }}
          className="md:w-[40%] w-full pl-10 p-4 border border-[#D1D5DC] rounded-md outline-none text-[#99A1AF] placeholder:text-[#99A1AF]"
        />
      </div>

      {/* Stats */}
      <div className="grid grid-cols-12 gap-4 mt-6">
        <div className="col-span-12 md:col-span-4 bg-white p-6 rounded-lg border-2 border-[#E5E7EB]">
          <p className="text-[#4A5565]">Total Users</p>
          <p className="text-xl font-semibold text-[#0A0A0A] mt-1">{users.length}</p>
        </div>

        <div className="col-span-12 md:col-span-4 bg-white p-6 rounded-lg border-2 border-[#E5E7EB]">
          <p className="text-[#4A5565]">Active Users</p>
          <p className="text-xl font-semibold text-green-600 mt-1">
            {users.filter((u) => u.status === "ACTIVE").length}
          </p>
        </div>

        <div className="col-span-12 md:col-span-4 bg-white p-6 rounded-lg border-2 border-[#E5E7EB]">
          <p className="text-[#4A5565]">Managers</p>
          <p className="text-xl font-semibold text-blue-600 mt-1">
            {users.filter((u) => u.role === "MANAGER").length}
          </p>
        </div>

        <div className="col-span-12 bg-white rounded-lg border-2 border-[#E5E7EB] overflow-x-scroll md:overflow-hidden">
          <Table TableHeads={TableHeads} TableRows={paginatedData} />
        </div>
      </div>

      <div className="flex justify-center mt-4">
        <Pagination
          totalPages={totalPages}
          currentPage={currentPage}
          setCurrentPage={setCurrentPage}
        />
      </div>

      {deleteUserId && (
  <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50">
    <div className="bg-white rounded-lg w-[90%] max-w-md p-6">
      
      <h3 className="text-xl font-semibold text-[#0A0A0A]">
        Delete User
      </h3>

      <p className="text-[#4A5565] mt-2">
        Are you sure you want to delete this user?
        This action cannot be undone.
      </p>

      <div className="flex justify-end gap-3 mt-6">
        <button
          onClick={() => setDeleteUserId(null)}
          className="px-4 py-2 rounded-md bg-[#E5E7EB] text-[#364153]"
        >
          Cancel
        </button>

        <button
          onClick={() => deleteMutation.mutate(deleteUserId)}
          disabled={deleteMutation.isPending}
          className="px-4 py-2 rounded-md bg-[#E7000B] text-white"
        >
          {deleteMutation.isPending ? "Deleting..." : "Delete"}
        </button>
      </div>
    </div>
  </div>
)}

    </div>
  );
};

export default UserManagement;
