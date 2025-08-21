import React from "react";

const plansData = [
  {
    id: 1,
    type: "current",
    name: "Professional",
    employeesUsed: 24,
    employeesLimit: 50,
    monthlyCost: 149,
    nextBilling: "2026-02-15",
  },
  {
    id: 2,
    type: "previous",
    name: "Basic",
    employeesUsed: 40,
    employeesLimit: 50,
    monthlyCost: 14,
    nextBilling: "2026-01-05",
  },
  {
    id: 3,
    type: "previous",
    name: "Basic",
    employeesUsed: 40,
    employeesLimit: 50,
    monthlyCost: 14,
    nextBilling: "2025-12-05",
  },
];

const PlanList = () => {
  return (
    <div className="space-y-8  mt-12">
      <h3 className="text-xl  text-[#0A0A0A] ">Plan list</h3>

      {plansData.map((plan) => {
        const isCurrent = plan.type === "current";
        const usagePercent = (plan.employeesUsed / plan.employeesLimit) * 100;

        return (
          <div
            key={plan.id}
            className={`rounded-lg border p-6 ${
              isCurrent
                ? "bg-[#F6A62D] border-[#F6A62D]"
                : "bg-[#FFF6E9] border-[#FFF6E9]"
            }`}
          >
            <div className="grid grid-cols-12 gap-6 items-center">
              {/* PLAN TYPE */}
              <div className="col-span-3">
                <p className="text-sm text-[#4A5565]">
                  {isCurrent ? "Current Plan" : "Previous Plan"}
                </p>
                <p
                  className={`text-2xl ${
                    isCurrent ? "text-white" : "text-[#4A5565]"
                  }`}
                >
                  {plan.name}
                </p>
              </div>

              {/* EMPLOYEE COUNT */}
              <div className="col-span-3">
                <p className="text-sm text-[#4A5565]">Employee Count</p>
                <p
                  className={`text-2xl ${
                    isCurrent ? "text-white" : "text-[#4A5565]"
                  }`}
                >
                  {plan.employeesUsed} / {plan.employeesLimit}
                </p>
              </div>

              {/* COST */}
              <div className="col-span-3">
                <p className="text-sm text-[#4A5565]">Monthly Cost</p>
                <p
                  className={`text-2xl${
                    isCurrent ? "text-white" : "text-[#4A5565]"
                  }`}
                >
                  ${plan.monthlyCost}
                </p>
              </div>

              {/* NEXT BILLING */}
              <div className="col-span-3">
                <p className="text-sm text-[#4A5565]">Next Billing</p>
                <p
                  className={`text-2xl ${
                    isCurrent ? "text-white" : "text-[#4A5565]"
                  }`}
                >
                  {new Date(plan.nextBilling).toLocaleDateString("en-US", {
                    month: "short",
                    day: "2-digit",
                    year: "numeric",
                  })}
                </p>
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
};

export default PlanList;
