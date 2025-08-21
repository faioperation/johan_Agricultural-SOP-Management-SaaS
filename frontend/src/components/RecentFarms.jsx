import React from "react";
import Table from "./Table";

const RecentFarms = ({ farms = [] }) => {

  const TableRows = farms.map((farm) => ({
    id: farm.id,
    name: farm.name,
    status: farm.status, // ACTIVE / TRIAL
    users: farm.users,
    plan: farm.plan,
    revenue: `$${farm.revenue}`,
  }));

  const TableHeads = [
    {
      Title: "Farm Name",
      key: "name",
      width: "25%",
    },
    {
      Title: "Status",
      key: "status",
      width: "15%",
      render: (row) => (
        <span
          className={`px-3 py-1 rounded-md text-sm font-medium ${
            row.status === "ACTIVE"
              ? "bg-green-100 text-green-700"
              : "bg-yellow-100 text-yellow-700"
          }`}
        >
          {row.status}
        </span>
      ),
    },
    {
      Title: "Users",
      key: "users",
      width: "15%",
    },
    {
      Title: "Plan",
      key: "plan",
      width: "25%",
    },
    {
      Title: "Revenue",
      key: "revenue",
      width: "20%",
    },
  ];

  if (!farms.length) {
    return <div>No farms found</div>;
  }

  return (
    <div>
      <Table TableHeads={TableHeads} TableRows={TableRows} />
    </div>
  );
};

export default RecentFarms;
