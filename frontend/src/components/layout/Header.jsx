import { FiMenu } from "react-icons/fi";

export default function Header({ onMenuClick }) {
  return (
    <header className="2xl:hidden bg-[#F9FAFB] flex items-center p-4 ">
      <button
        onClick={onMenuClick}
        className="p-2 rounded bg-[#F6A62D] text-white cursor-pointer"
      >
        <FiMenu size={22} />
      </button>
    </header>
  );
}
