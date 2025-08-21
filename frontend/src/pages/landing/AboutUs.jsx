import React from 'react'
import { useNavigate } from 'react-router-dom'
import { IoArrowBack } from 'react-icons/io5'
import { MdOutlineEmail, MdOutlinePhone } from 'react-icons/md'

const AboutUs = () => {
  const navigate = useNavigate()

  return (
    <div className="min-h-screen bg-white">

      {/* Top Info Bar */}
      <div className="w-full border-b border-gray-200 px-4 sm:px-8 py-3 flex items-center justify-between text-xs sm:text-sm text-[#364153]">
        <button
          onClick={() => navigate(-1)}
          className="flex items-center justify-center w-8 h-8 sm:w-9 sm:h-9 rounded-full border border-gray-300 hover:bg-gray-100 transition-colors flex-shrink-0"
        >
          <IoArrowBack className="w-4 h-4 text-[#364153]" />
        </button>

        <span className="hidden sm:inline">Hello! Welcome to Farm-Check</span>

        <div className="flex items-center gap-2 sm:gap-6">
          <span className="flex items-center gap-1">
            <MdOutlineEmail className="w-4 h-4" />
            <span className="hidden md:inline">demo@gmail.com</span>
          </span>
          <span className="flex items-center gap-1">
            <MdOutlinePhone className="w-4 h-4" />
            <span className="hidden md:inline">+1 707-699-6478</span>
          </span>
        </div>
      </div>

      {/* Content */}
      <div className="w-full px-4 sm:px-8 lg:px-16 pt-8 pb-16 ">
        <h1 className="text-3xl sm:text-4xl lg:text-6xl font-bold text-[#1A1A1A] mb-6 sm:mb-8">About Us</h1>

        <div className="space-y-4 sm:space-y-5 text-[#364153] text-base sm:text-lg lg:text-3xl leading-relaxed">
          <p>
            Farm-Check is a modern platform designed to simplify farm operations and improve team
            communication. Our goal is to help farms manage daily tasks, standard operating
            procedures (SOP), and employee coordination in a simple and efficient way.
          </p>
          <p>
            We understand that farm work happens in the field, not in the office. That's why Farm-Check
            provides tools that allow farm owners and managers to organize workflows, assign tasks, and
            ensure that procedures are followed consistently.
          </p>
          <p>
            With features like SOP management, task checklists, offline access, and real-time tracking,
            Farm-Check helps farms improve productivity while reducing mistakes.
          </p>
          <p>
            Our mission is to empower farms with simple technology that makes daily operations
            smoother, more organized, and more efficient.
          </p>
        </div>
      </div>

    </div>
  )
}

export default AboutUs
