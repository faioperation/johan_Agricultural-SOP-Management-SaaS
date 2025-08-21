import React, { useRef, useState } from "react";
import { FiUploadCloud } from "react-icons/fi";

const UploadPDF = ({ onFileSelect, existingPdf, existingFileName }) => {
  const inputRef = useRef(null);
  const [dragActive, setDragActive] = useState(false);
  const [error, setError] = useState("");
  const [fileName, setFileName] = useState("");

  const MAX_SIZE = 10 * 1024 * 1024; // 10MB

  const validateFile = (file) => {
    if (file.type !== "application/pdf") {
      setError("Only PDF files are allowed");
      return false;
    }
    if (file.size > MAX_SIZE) {
      setError("File size must be less than 10MB");
      return false;
    }
    setError("");
    return true;
  };

  const handleFile = (file) => {
    if (!file) return;
    if (!validateFile(file)) return;

    setFileName(file.name);
    onFileSelect && onFileSelect(file);
  };

  const handleDrop = (e) => {
    e.preventDefault();
    setDragActive(false);
    handleFile(e.dataTransfer.files[0]);
  };

  const handleChange = (e) => {
    handleFile(e.target.files[0]);
  };

  return (
    <div
      onDragOver={(e) => {
        e.preventDefault();
        setDragActive(true);
      }}
      onDragLeave={() => setDragActive(false)}
      onDrop={handleDrop}
      onClick={() => inputRef.current.click()}
      className={`border-2 border-[#D1D5DC] rounded-lg p-12 text-center cursor-pointer transition
        ${
          dragActive
            ? "border-[#F6A62D] bg-[#FFF4E5]"
            : "border-[#D1D5DC]"
        }`}
    >
      <FiUploadCloud className="mx-auto text-4xl text-[#6B7280]" />

      <p className="mt-3 text-[#4A5565]">
        Click to upload or drag and drop
      </p>

      <p className="text-xs text-[#9CA3AF] mt-1">
        PDF files only (Max 10MB)
      </p>

      {/* Show existing file if no new file selected */}
      {!fileName && existingPdf && (
           <div className="mt-3">
             <p className="text-sm text-[#4A5565]">Current File:</p>
             <a 
               href={existingPdf} 
               target="_blank" 
               rel="noopener noreferrer"
               className="text-[#F6A62D] hover:underline text-sm break-all"
               onClick={(e) => e.stopPropagation()} // Prevent triggering upload click
             >
               {existingFileName || existingPdf.split('/').pop()}
             </a>
           </div>
      )}

      {fileName && (
        <p className="mt-3 text-sm text-green-600">
          Selected file: {fileName}
        </p>
      )}

      {error && (
        <p className="mt-2 text-sm text-red-500">{error}</p>
      )}

      <input
        ref={inputRef}
        type="file"
        accept="application/pdf"
        hidden
        onChange={handleChange}
      />
    </div>
  );
};

export default UploadPDF;