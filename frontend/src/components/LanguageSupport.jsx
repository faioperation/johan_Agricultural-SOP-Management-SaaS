import React, { useState } from "react";
import { FiGlobe } from "react-icons/fi";

const LanguageSupportUI = () => {
  const [checked, setChecked] = useState({
    en: true,
    nl: false,
  });

  const toggle = (key) => {
    setChecked((prev) => ({
      ...prev,
      [key]: !prev[key],
    }));
  };

  return (
    <div className="bg-white p-6 rounded-lg border-2 border-[#E5E7EB]">
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <div className="w-9 h-9 flex items-center justify-center rounded-lg bg-[#E0EAFF] text-[#2970FF]">
          <FiGlobe size={18} />
        </div>
        <h3 className="text-xl text-[#0A0A0A]">
          Language Support
        </h3>
      </div>

      {/* Default Platform Language */}
      <div className="mb-6">
        <p className="text-sm text-[#364153]">
          Default Platform Language
        </p>
      </div>

      {/* Enabled Languages */}
      <div>
        <p className="text-sm text-[#364153] mb-3">
          Enabled Languages
        </p>

        <div className="space-y-3">
          {/* English */}
          <label className="flex items-center gap-3 cursor-pointer">
            <input
              type="checkbox"
              checked={checked.en}
              onChange={() => toggle("en")}
              className="w-4 h-4 accent-[#2970FF]"
            />
            <span className="text-sm text-[#101828]">
              English
            </span>
          </label>

          {/* Dutch */}
          <label className="flex items-center gap-3 cursor-pointer">
            <input
              type="checkbox"
              checked={checked.nl}
              onChange={() => toggle("nl")}
              className="w-4 h-4 accent-[#2970FF]"
            />
            <span className="text-sm text-[#101828]">
              Dutch
            </span>
          </label>
        </div>
      </div>
    </div>
  );
};

export default LanguageSupportUI;
