import { Outlet } from "react-router-dom";

export default function AuthLayout() {
  return (
    <div className="min-h-screen flex bg-[#FFF6E9]">
     
      <div className=" flex items-center justify-center flex-1">
        <Outlet />
      </div>

      
     
    </div>
  );
}
