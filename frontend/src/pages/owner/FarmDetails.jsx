import { FaCalendarAlt } from "react-icons/fa";
import { FaArrowLeft } from "react-icons/fa6";
import { FiUsers } from "react-icons/fi";
import { HiOfficeBuilding } from "react-icons/hi";
import { MdDelete, MdRestartAlt } from "react-icons/md";
import { useParams, useNavigate } from "react-router-dom";
import {
  useQuery,
  useMutation,
  useQueryClient,
} from "@tanstack/react-query";
import useAxiosSecure from "../../hooks/useAxiosSecure";
import toast from "react-hot-toast";
import { useState } from "react";

const StatCard = ({ icon, title, value, sub }) => (
  <div className="bg-white p-6 rounded-lg border-2 border-[#E5E7EB] flex gap-4 col-span-12 md:col-span-4">
    <div className="text-indigo-600 mt-1">{icon}</div>
    <div>
      <p className="text-sm text-[#4A5565]">{title}</p>
      <p className="text-3xl text-[#0A0A0A] my-2">{value}</p>
      <p className="text-xs text-[#6A7282]">{sub}</p>
    </div>
  </div>
);

const InfoRow = ({ label, value }) => (
  <div className="flex items-center justify-between py-2 border-b border-[#F3F4F6]">
    <span className="text-gray-500">{label}</span>
    <span className="font-medium text-[#0A0A0A]">{value}</span>
  </div>
);

const FarmDetails = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const axiosSecure = useAxiosSecure();
  const queryClient = useQueryClient();
  const [showDeleteModal, setShowDeleteModal] = useState(false);

  const formatDate = (dateString) =>
    new Date(dateString).toISOString().split("T")[0];

  //   Fetch Farm
  const { data: farm, isLoading, isError } = useQuery({
    queryKey: ["farmDetails", id],
    queryFn: async () => {
      const res = await axiosSecure.get(`/system-owner/farm/${id}`);
      return res.data.data;
    },
  });

  //   Status Toggle
  const statusMutation = useMutation({
    mutationFn: async () => {
      const newStatus =
        farm.status === "ACTIVE"
          ? "INACTIVE"
          : "ACTIVE";

      return await axiosSecure.patch(
        `/system-owner/farm/${id}/status`,
        { status: newStatus }
      );
    },
    onSuccess: () => {
      toast.success("Farm status updated");
      queryClient.invalidateQueries(["farmDetails", id]);
      queryClient.invalidateQueries(["farms"]);
    },
    onError: (error) => {
      toast.error(
        error?.response?.data?.message ||
        "Failed to update status"
      );
    },
  });

  //   Delete Farm
  const deleteMutation = useMutation({
    mutationFn: async () => {
      return await axiosSecure.delete(`/system-owner/farm/${id}`);
    },
    onSuccess: () => {
      toast.success("Farm deleted successfully");
      queryClient.invalidateQueries(["farms"]);
      navigate("/owner/farm/management");
    },
    onError: (error) => {
      toast.error(
        error?.response?.data?.message ||
        "Failed to delete farm"
      );
    },
  });

  if (isLoading) return <div className="p-10">Loading farm details...</div>;
  if (isError || !farm)
    return <p className="text-red-500">Farm not found</p>;

  const statusStyles = {
    ACTIVE: "bg-green-100 text-green-600",
    INACTIVE: "bg-red-100 text-red-600",
    TRIAL: "bg-yellow-100 text-yellow-600",
  };

  return (
    <div className="space-y-6">

      {/* Back */}
      <div
        onClick={() => navigate(-1)}
        className="flex items-center gap-2 cursor-pointer"
      >
        <FaArrowLeft className="text-[#4A5565]" />
        <p className="text-[#4A5565]">Back to Farms</p>
      </div>

      {/* Header */}
      <div className="bg-white p-6 rounded-lg border-2 border-[#E5E7EB] md:flex items-center md:justify-between gap-5">

        <div className="flex items-center gap-4">
          <div className="p-3 bg-orange-100 rounded-lg text-orange-600">
            <HiOfficeBuilding size={22} />
          </div>

          <div>
            <h2 className="text-3xl text-[#0A0A0A]">{farm.name}</h2>
            <p className="text-sm text-[#4A5565] mt-1">{farm.adminEmail}</p>

            <span
              className={`inline-block mt-2 px-3 py-1 text-xs rounded-full font-medium
                ${statusStyles[farm.status] || "bg-gray-100 text-gray-600"}`}
            >
              {farm.status}
            </span>
          </div>
        </div>

        {/* Buttons */}
        <div className="flex items-center gap-3 mt-3 md:mt-0 justify-center">

          {/* Status */}
          <button
            onClick={() => statusMutation.mutate()}
            disabled={statusMutation.isPending}
            className={`md:px-4 px-2 py-2 rounded-md border ${
              farm.status === "ACTIVE"
                ? "border-[#D08700] text-[#D08700]"
                : "border-green-600 text-green-600"
            }`}
          >
            {statusMutation.isPending
              ? "Updating..."
              : farm.status === "ACTIVE"
              ? "Suspend Farm"
              : "Activate Farm"}
          </button>

          {/* Reset Placeholder */}
          {/* <button className="md:px-4 px-2 py-2 rounded-md border border-[#D1D5DC] text-[#0A0A0A] hover:bg-gray-50 flex items-center gap-2">
            <MdRestartAlt /> Reset Access
          </button> */}

          {/* Delete */}
          <button
            onClick={() => setShowDeleteModal(true)}
            className="md:px-4 px-2 py-2 rounded-md border border-[#E7000B] text-[#E7000B] hover:bg-red-50 flex items-center gap-2"
          >
            <MdDelete /> Delete
          </button>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-12 gap-6">
        <StatCard
          icon={<FiUsers />}
          title="Total Users"
          value={farm.totalUsers}
          sub={`Limit: ${farm.employeeLimit}`}
        />
        <StatCard
          icon={<HiOfficeBuilding />}
          title="Plan"
          value={farm.plan}
          sub="Current subscription"
        />
        <StatCard
          icon={<FaCalendarAlt />}
          title="Created"
          value={formatDate(farm.createdAt)}
          sub="Farm creation date"
        />
      </div>

      {/* Info */}
      <div className="grid grid-cols-1 xl:grid-cols-2 gap-6">
        <div className="bg-white p-6 rounded-lg border-2 border-[#E5E7EB]">
          <h3 className="text-xl mb-4 text-[#0A0A0A]">Farm Information</h3>
          <InfoRow label="Farm ID" value={farm.id.slice(32, 36)} />
          <InfoRow label="Country" value={farm.country} />
          <InfoRow label="Language" value={farm.language} />
          <InfoRow label="Admin Email" value={farm.adminEmail} />
          <InfoRow label="Employee Limit" value={farm.employeeLimit} />
        </div>
      <div className="bg-white p-6 rounded-lg border-2 border-[#E5E7EB]">
          <h3 className="text-xl text-[#0A0A0A] mb-4">Recent Activity</h3>
          <p className="text-gray-500 text-sm">
            No recent activity available
          </p>
        </div>
      </div>


      {/* Delete Modal */}
      {showDeleteModal && (
        <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg w-[90%] max-w-md p-6">
            <h3 className="text-xl font-semibold text-[#0A0A0A]">
              Delete Farm
            </h3>

            <p className="text-[#4A5565] mt-2">
              Are you sure you want to delete this farm?
              This action cannot be undone.
            </p>

            <div className="flex justify-end gap-3 mt-6">
              <button
                onClick={() => setShowDeleteModal(false)}
                className="px-4 py-2 rounded-md bg-[#E5E7EB] text-[#364153]"
              >
                Cancel
              </button>

              <button
                onClick={() => {
                  deleteMutation.mutate();
                  setShowDeleteModal(false);
                }}
                disabled={deleteMutation.isPending}
                className="px-4 py-2 rounded-md bg-[#E7000B] text-white"
              >
                {deleteMutation.isPending
                  ? "Deleting..."
                  : "Delete"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default FarmDetails;
