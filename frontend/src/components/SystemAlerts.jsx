import React from "react";
import { FiAlertCircle } from "react-icons/fi";

const alertStyles = {
  SUBSCRIPTION_EXPIRING: {
    border: "border-[#FFF085]",
    bg: "bg-[#FEFCE8]",
    icon: "text-[#D08700]",
  },
  PAYMENT_FAILED: {
    border: "border-[#FFC9C9]",
    bg: "bg-[#FEF2F2]",
    icon: "text-[#E7000B]",
  },
  SYSTEM: {
    border: "border-[#BEDBFF]",
    bg: "bg-[#EFF6FF]",
    icon: "text-[#155DFC]",
  },
};

const SystemAlerts = ({ alerts }) => {
  return (
    <div className="space-y-5">
      {alerts.map((alert) => {
        const styles = alertStyles[alert.type];

        return (
          <div
            key={alert.id}
            className={`flex gap-4 p-5 rounded-xl border ${styles.border} ${styles.bg}`}
          >
            <FiAlertCircle size={24} className={`${styles.icon} flex mt-0.5`} />

            <div>
              <p className="text-[#101828] text-base font-medium">
                {alert.message}
              </p>
              <p className="text-sm text-[#6A7282] mt-1">{alert.time}</p>
            </div>
          </div>
        );
      })}
    </div>
  );
};

export default SystemAlerts;
