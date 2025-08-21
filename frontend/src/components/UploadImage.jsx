import React, { useRef, useState } from "react";
import { FiUpload, FiTrash2 } from "react-icons/fi";

const UploadImage = ({label,branding}) => {
  const fileInputRef = useRef(null);
  const [logo, setLogo] = useState(null);
  const [error, setError] = useState("");

  /* ===== HANDLE FILE SELECT ===== */
  const handleFileChange = (e) => {
    const file = e.target.files[0];
    if (!file) return;

    // validation
    if (!file.type.startsWith("image/")) {
      setError("Only image files are allowed");
      return;
    }

    if (file.size > 2 * 1024 * 1024) {
      setError("Image size must be under 2MB");
      return;
    }

    setError("");
    setLogo(URL.createObjectURL(file));

    // 🔌 API hook (later)
    // uploadLogoToServer(file)
  };

  /* ===== REMOVE LOGO ===== */
  const removeLogo = () => {
    setLogo(null);
    fileInputRef.current.value = "";
  };

  return (
     <div className="bg-white p-6 rounded-lg border-2 border-[#E5E7EB] ">
      {/* HEADER */}
      <div className="flex items-center gap-3 mb-6">
        <div className="w-9 h-9 flex items-center justify-center rounded-lg bg-[#F3E8FF] text-[#7C3AED]">
          🎨
        </div>
        <h3 className="text-xl  text-[#0A0A0A]">
         {branding} Branding
        </h3>
      </div>

      {/* LOGO LABEL */}
      <p className="text-sm text-[#364153] mb-2">{label}</p>

      {/* CONTENT */}
      <div className="flex items-center gap-6">
        {/* LOGO PREVIEW */}
        <div className="w-24 h-24 border-2  border-[#D1D5DC] rounded-lg flex items-center justify-center overflow-hidden">
          {logo ? (
            <img
              src={logo}
              alt="Platform Logo"
              className="w-full h-full object-contain"
            />
          ) : (
            <span className="text-sm text-[#9CA3AF]">Logo</span>
          )}
        </div>

        {/* ACTIONS */}
        <div className="flex flex-col gap-2">
          <input
            ref={fileInputRef}
            type="file"
            accept="image/*"
            hidden
            onChange={handleFileChange}
          
          />

          <button
            onClick={() => fileInputRef.current.click()}
            className="flex items-center gap-2 px-4 py-2 border border-[#D1D5DC] rounded-lg text-sm hover:bg-gray-50 text-[#0A0A0A] cursor-pointer"
          >
            <FiUpload />
            Upload New Logo
          </button>

          {logo && (
            <button
              onClick={removeLogo}
              className="cursor-pointer flex items-center gap-2 text-sm text-red-600 hover:text-red-700"
            >
              <FiTrash2 />
              Remove Logo
            </button>
          )}
        </div>
      </div>

      {/* ERROR */}
      {error && (
        <p className="text-sm text-red-600 mt-3 ">{error}</p>
      )}

      {/* HELPER */}
      <p className="text-xs text-[#6A7282] mt-4">
        Supported formats: JPG, PNG, SVG. Max size 2MB.
      </p>
    </div>
  );
};

export default UploadImage;
