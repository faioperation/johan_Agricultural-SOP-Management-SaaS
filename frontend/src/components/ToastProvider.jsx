"use client";

import { Toaster } from "react-hot-toast";

export function ToastProvider({ children }) {
  return (
    <>
      <Toaster position="top-center" />
      {children}
    </>
  );
}
