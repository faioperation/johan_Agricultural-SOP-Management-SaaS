import React, { useState } from "react";
import Breadcrumb from "../../components/Bredcumb";
import { FaPlus } from "react-icons/fa6";
import { FaSearch } from "react-icons/fa";
import FarmCard from "../../components/FarmCard";
import { Link } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import useAxiosSecure from "../../hooks/useAxiosSecure";

const FarmManagement = () => {
  const [search, setSearch] = useState("");
  const axiosSecure = useAxiosSecure();

  const {
    data: farms = [],
    isLoading,
    isError,
  } = useQuery({
    queryKey: ["farms"],
    queryFn: async () => {
      const res = await axiosSecure.get("/system-owner/farm");
      return res.data.data.farms; //   correct response path
    },
  });

  const handleStatusChange = (id) => {
    console.log("Status change clicked for:", id);
  };

  const filteredFarms = farms.filter((farm) => {
    const query = search.toLowerCase();
    return (
      farm.name?.toLowerCase().includes(query) ||
      farm.adminEmail?.toLowerCase().includes(query)
    );
  });

  if (isLoading) {
    return <div className="p-10">Loading farms...</div>;
  }

  if (isError) {
    return (
      <div className="p-10 text-red-500">
        Failed to load farms
      </div>
    );
  }
  

  return (
    <div>
      <div className="flex items-center justify-between">
        <div>
          <Breadcrumb />
          <p className="text-[#4A5565] text-sm md:text-base mt-1.5">
            Manage all farms across the platform
          </p>
        </div>

        <Link to="/owner/farm/management/create/farm">
          <button className="bg-[#F6A62D] text-white px-4 py-2 rounded-md flex items-center gap-2 hover:bg-[#e5942b] cursor-pointer">
            <FaPlus />
            Create New Farm
          </button>
        </Link>
      </div>

      {/* Search */}
      <div className="relative mt-6 bg-white p-6 rounded-lg border-2 border-[#E5E7EB]">
        <FaSearch className="absolute top-1/2 -translate-y-1/2 left-10 text-[#99A1AF]" />
        <input
          type="text"
          placeholder="Search farms by name or admin email..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="w-full pl-10 p-4 border border-[#D1D5DC] rounded-md outline-none text-[#0A0A0A]/50 placeholder:text-[#0A0A0A]/50"
        />
      </div>

      {/* Farm Cards */}
      <div className="grid grid-cols-12 gap-6 mt-6">
        {filteredFarms.map((farm) => (
          <FarmCard
            key={farm.id}
            farm={farm}
            onStatusChange={handleStatusChange}
          />
        ))}
      </div>
    </div>
  );
};

export default FarmManagement;
