import React from "react";
import bannerPhone from "/bannerPhone.png";
import { motion } from "framer-motion";
import Container from "../../components/Container";
import Image from "../../components/Image";

const Banner = () => {
  return (
    <div id="home" className="overflow-hidden">
      <Container className="md:border border-black/5 md:bg-[#F8FAFC] rounded-3xl md:flex items-center justify-between px-4 py-8 md:p-12 mt-6 shadow-sm">
        {/* Left Side (Text content) */}
        <motion.div
          initial={{ opacity: 0, x: -30 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.8, ease: [0.16, 1, 0.3, 1] }}
          className="md:w-[55%] z-10"
        >
          <motion.h3
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.2 }}
            className="font-inter font-bold text-3xl md:text-[48px] text-center md:text-left leading-tight"
          >
            A simple way to manage farm
            <span className="text-[#F6A62D] block md:inline"> SOP’s & Tasks </span>
            and team communication
          </motion.h3>
          <motion.p
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.35 }}
            className="font-inter text-lg md:text-xl text-slate-600 mb-10 mt-6 text-center md:text-left max-w-xl"
          >
            Built for dairy farms. Works offline. Easy for every employee. Ensure consistent procedures and reduce costly mistakes.
          </motion.p>

          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.5 }}
            className="flex flex-col sm:flex-row items-center justify-center md:justify-start gap-4 md:gap-6"
          >

            <motion.button 
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.98 }}
              onClick={() => {
                const el = document.getElementById("pricing");
                if (el) el.scrollIntoView({ behavior: "smooth", block: "start" });
              }}
              className="bg-[#F6A62D] text-white font-bold px-10 py-4 rounded-2xl cursor-pointer shadow-lg shadow-orange-500/30 transition-shadow hover:shadow-orange-500/40 w-full sm:w-auto text-lg"
            >
              Get Started
            </motion.button>
            
           
          </motion.div>
        </motion.div>

        {/* Right Side (Image) */}
        <motion.div
          initial={{ opacity: 0, scale: 0.85, x: 50 }}
          animate={{ opacity: 1, scale: 1, x: 0 }}
          transition={{ duration: 1, delay: 0.3, ease: [0.16, 1, 0.3, 1] }}
          className="flex justify-center mt-12 md:mt-0 relative"
        >
          <motion.div
            animate={{ 
              y: [0, -20, 0],
              rotate: [0, 1, 0, -1, 0]
            }}
            transition={{ 
              y: { duration: 5, repeat: Infinity, ease: "easeInOut" },
              rotate: { duration: 8, repeat: Infinity, ease: "easeInOut" }
            }}
            className="relative z-10"
          >
            <Image src={bannerPhone} alt="banner" className="max-w-[300px] md:max-w-md drop-shadow-2xl" />
          </motion.div>
          
          {/* Decorative background element */}
          <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[120%] h-[120%] bg-orange-100/50 rounded-full blur-3xl -z-0" />
        </motion.div>
      </Container>
    </div>
  );
};

export default Banner;
