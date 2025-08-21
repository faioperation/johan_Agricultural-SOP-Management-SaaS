import React from "react";
import { Eye, Pause, Play } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import useAxiosSecure from "../hooks/useAxiosSecure";
import toast from "react-hot-toast";

function FarmCard({ farm }) {
  const navigate = useNavigate();
  const axiosSecure = useAxiosSecure();
  const queryClient = useQueryClient();

  const formatDate = (dateString) =>
    new Date(dateString).toISOString().split("T")[0];

  const statusConfig = {
    ACTIVE: "bg-green-100 text-green-600",
    TRIAL: "bg-yellow-100 text-yellow-600",
    INACTIVE: "bg-red-100 text-red-600",
  };

  const badgeClass =
    statusConfig[farm.status] ?? "bg-gray-100 text-gray-600";

  //   Status Toggle Mutation
 const statusMutation = useMutation({
  mutationFn: async () => {

    const newStatus =
      farm.status === "ACTIVE"
        ? "INACTIVE"
        : "ACTIVE";

    return await axiosSecure.patch(
      `/system-owner/farm/${farm.id}/status`,
      { status: newStatus }   // ✅ BODY SEND করছি
    );
  },
  onSuccess: () => {
    toast.success("Farm status updated");
    queryClient.invalidateQueries(["farms"]);
  },
  onError: (error) => {
    console.log(error);
    toast.error(
      error?.response?.data?.message ||
      "Failed to update status"
    );
  },
});


  return (
    <div className="bg-white p-6 rounded-lg border-2 border-[#E5E7EB] flex flex-col gap-4 shadow-sm hover:shadow-md transition col-span-12 md:col-span-4">

      {/* Header */}
      <div className="flex items-start justify-between">
        <div>
          <h3 className="font-semibold text-gray-900">{farm.name}</h3>
          <p className="text-sm text-gray-500">{farm.adminEmail}</p>
        </div>

        <span className={`px-3 py-1 text-xs rounded-full font-medium ${badgeClass}`}>
          {farm.status}
        </span>
      </div>

      {/* Info */}
      <div className="grid grid-cols-2 gap-y-3 text-sm">
        <Info label="Plan" value={farm.plan} />
        <Info label="Users" value={farm.users} />
        <Info label="Country" value={farm.country} />
        <Info label="Created" value={formatDate(farm.createdAt)} />
      </div>

      {/* Footer */}
      <div className="flex items-center gap-3 mt-2">
        <button
          onClick={() =>
            navigate(`/owner/farm/management/details/${farm.id}`)
          }
          className="flex-1 flex items-center justify-center gap-2 rounded-lg bg-indigo-50 text-indigo-600 py-2 text-sm font-medium hover:bg-indigo-100"
        >
          <Eye size={16} />
          View Details
        </button>

        {/* Suspend / Activate Button */}
        {farm.status !== "TRIAL" && (
          <button
            onClick={() => statusMutation.mutate()}
            disabled={statusMutation.isPending}
            className={`p-2 rounded-lg border transition ${
              farm.status === "ACTIVE"
                ? "text-gray-600 hover:bg-gray-100"
                : "text-green-600 hover:bg-green-50"
            }`}
          >
            {statusMutation.isPending ? (
              "..."
            ) : farm.status === "ACTIVE" ? (
              <Pause size={16} />
            ) : (
              <Play size={16} />
            )}
          </button>
        )}
      </div>
    </div>
  );
}

const Info = ({ label, value }) => (
  <div>
    <p className="text-gray-500">{label}</p>
    <p className="text-[#0A0A0A]">{value}</p>
  </div>
);

export default React.memo(FarmCard);
