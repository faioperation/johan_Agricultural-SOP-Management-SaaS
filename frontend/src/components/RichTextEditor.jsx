import React, { useRef, useState, useEffect } from "react";
import {
  FiBold,
  FiItalic,
  FiList,
  FiImage,
  FiTrash2,
  FiAlignLeft,
  FiAlignCenter,
  FiAlignRight,
} from "react-icons/fi";

/* ===== ALIGN CONFIG ===== */
const ALIGN_ORDER = ["left", "center", "right"];

const ALIGN_COMMAND = {
  left: "justifyLeft",
  center: "justifyCenter",
  right: "justifyRight",
};

const ALIGN_ICON = {
  left: FiAlignLeft,
  center: FiAlignCenter,
  right: FiAlignRight,
};

/* ===== ALIGN NORMALIZER (CRASH FIX) ===== */
const normalizeAlign = (align) => {
  if (align === "center") return "center";
  if (align === "right" || align === "end") return "right";
  return "left"; // start, justify, initial, undefined
};

import toast from "react-hot-toast";

const RichTextEditor = ({ value, onChange, onImageUpload }) => {
  const editorRef = useRef(null);
  const fileInputRef = useRef(null);
  const savedRange = useRef(null);

  const [active, setActive] = useState({
    bold: false,
    italic: false,
    ul: false,
    ol: false,
    align: "left",
  });

  const [selectedImage, setSelectedImage] = useState(null);

  /* ===== SELECTION ===== */
  const saveSelection = () => {
    const sel = window.getSelection();
    if (sel.rangeCount > 0) {
      savedRange.current = sel.getRangeAt(0);
    }
  };

  const restoreSelection = () => {
    const sel = window.getSelection();
    if (savedRange.current) {
      sel.removeAllRanges();
      sel.addRange(savedRange.current);
    }
  };

  /* ===== ACTIVE STATE ===== */
  const updateActive = () => {
    const sel = window.getSelection();
    let align = "left";

    if (sel && sel.anchorNode) {
      const el =
        sel.anchorNode.nodeType === 3
          ? sel.anchorNode.parentElement
          : sel.anchorNode;

      const style = window.getComputedStyle(el);
      align = normalizeAlign(style.textAlign);
    }

    setActive({
      bold: document.queryCommandState("bold"),
      italic: document.queryCommandState("italic"),
      ul: document.queryCommandState("insertUnorderedList"),
      ol: document.queryCommandState("insertOrderedList"),
      align,
    });

    onChange && onChange(editorRef.current.innerHTML);
  };

  /* ===== EXEC ===== */
  const exec = (command) => {
    restoreSelection();
    editorRef.current.focus();
    document.execCommand(command);
    updateActive();
  };

  /* ===== LIST ===== */
  const toggleList = (type) => {
    restoreSelection();
    editorRef.current.focus();
    document.execCommand(type);
    updateActive();
  };

  /* ===== SINGLE ALIGN BUTTON ===== */
  const handleAlignToggle = (e) => {
    e.preventDefault();

    const current = active.align || "left";
    const index = ALIGN_ORDER.indexOf(current);
    const next = ALIGN_ORDER[(index + 1) % ALIGN_ORDER.length];

    restoreSelection();
    editorRef.current.focus();
    document.execCommand(ALIGN_COMMAND[next]);
    updateActive();
  };

  /* ===== IMAGE ===== */
  const handleImageUpload = async (e) => {
    const file = e.target.files[0];
    if (!file) return;

    restoreSelection();
    editorRef.current.focus();

    let url;

    if (onImageUpload) {
      try {
        // Show loading placeholder or wait (simple wait for now)
        const toastId = toast.loading("Uploading image...");
        url = await onImageUpload(file);
        toast.dismiss(toastId);
        if(!url) throw new Error("Upload failed");
      } catch (err) {
        toast.error("Image upload failed");
        console.error(err);
        return;
      }
    } else {
       url = URL.createObjectURL(file);
    }
    
    document.execCommand("insertImage", false, url);

    setTimeout(bindImages, 0);
    updateActive();
    e.target.value = "";
  };

  const bindImages = () => {
    const imgs = editorRef.current.querySelectorAll("img");
    imgs.forEach((img) => {
      img.style.maxWidth = "100%";
      img.style.height = "auto";
      img.style.resize = "both";
      img.style.overflow = "auto";
      img.setAttribute("contenteditable", "false");
      img.onclick = () => setSelectedImage(img);
    });
  };

  const deleteImage = () => {
    if (selectedImage) {
      selectedImage.remove();
      setSelectedImage(null);
      updateActive();
    }
  };

  /* ===== EVENTS ===== */
  useEffect(() => {
    const editor = editorRef.current;

    editor.addEventListener("mouseup", saveSelection);
    editor.addEventListener("keyup", saveSelection);
    editor.addEventListener("mouseup", updateActive);
    editor.addEventListener("keyup", updateActive);

    // Initialize content
    if (value && editor.innerHTML !== value) {
        editor.innerHTML = value;
        bindImages();
    }


    return () => {
      editor.removeEventListener("mouseup", saveSelection);
      editor.removeEventListener("keyup", saveSelection);
      editor.removeEventListener("mouseup", updateActive);
      editor.removeEventListener("keyup", updateActive);
    };
  }, []); // Run once on mount

  // Watch for external value changes (e.g. from parent when editing)
  useEffect(() => {
    const editor = editorRef.current;
    if (value && editor.innerHTML !== value && document.activeElement !== editor) {
        editor.innerHTML = value;
        bindImages();
    }
  }, [value]);

  const AlignIcon = ALIGN_ICON[active.align] || FiAlignLeft;

  return (
    <div className="border rounded-lg overflow-hidden bg-white border-[#E5E7EB]">
      {/* ===== Toolbar ===== */}
      <div className="flex items-center gap-2 px-4 py-2 border-b bg-[#F9FAFB] border-[#E5E7EB]">
        <button
          onMouseDown={(e) => {
            e.preventDefault();
            exec("bold");
          }}
          className={`p-2 rounded cursor-pointer ${
            active.bold ? "bg-[#F3F3F5] text-[#4A5565]" : "text-[#4A5565]"
          }`}
        >
          <FiBold />
        </button>

        <button
          onMouseDown={(e) => {
            e.preventDefault();
            exec("italic");
          }}
          className={`p-2 rounded cursor-pointer ${
            active.italic ? "bg-[#F3F3F5] text-[#4A5565]" : "text-[#4A5565]"
          }`}
        >
          <FiItalic />
        </button>

        <button
          onMouseDown={(e) => {
            e.preventDefault();
            toggleList("insertUnorderedList");
          }}
          className={`p-2 rounded cursor-pointer ${
            active.ul ? "bg-[#F3F3F5] text-[#4A5565]" : "text-[#4A5565]"
          }`}
        >
          <FiList />
        </button>

        <button
          onMouseDown={(e) => {
            e.preventDefault();
            toggleList("insertOrderedList");
          }}
          className={`p-2 rounded cursor-pointer ${
            active.ol ? "bg-[#F3F3F5] text-[#4A5565]" : "text-[#4A5565]"
          }`}
        >
          <FiList />
        </button>

        {/* SINGLE ALIGN BUTTON */}
        <button
          onMouseDown={handleAlignToggle}
          className="p-2 rounded cursor-pointer bg-[#F3F3F5] text-[#4A5565]"
        >
          <AlignIcon />
        </button>

        {/* IMAGE */}
        <button
          onMouseDown={(e) => {
            e.preventDefault();
            fileInputRef.current.click();
          }}
          className="p-2 rounded text-[#4A5565] cursor-pointer"
        >
          <FiImage />
        </button>

        {selectedImage && (
          <button
            onMouseDown={(e) => {
              e.preventDefault();
              deleteImage();
            }}
            className="p-2 rounded text-[#4A5565] cursor-pointer"
          >
            <FiTrash2 />
          </button>
        )}

        <input
          ref={fileInputRef}
          type="file"
          accept="image/*"
          hidden
          onChange={handleImageUpload}
        />
      </div>

      {/* ===== Editor ===== */}
      <div
        ref={editorRef}
        contentEditable
        className="min-h-[220px] p-4 outline-none text-[#374151] bg-[#F3F3F5]"
        suppressContentEditableWarning
      />
    </div>
  );
};

export default RichTextEditor;
