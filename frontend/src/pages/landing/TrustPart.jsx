import React from "react";
import Container from "../../components/Container";
import { motion } from "framer-motion";
import {
  FiShield,
  FiLock,
  FiLayers,
  FiTrendingUp,
  FiDatabase,
} from "react-icons/fi";

const TrustPart = () => {
  const trustItems = [
    {
      icon: <FiShield className="w-6 h-6" />,
      label: "Built specifically for agriculture",
    },
    {
      icon: <FiLock className="w-6 h-6" />,
      label: "Bank-grade data security",
    },
    {
      icon: <FiDatabase className="w-6 h-6" />,
      label: "Scalable SaaS architecture",
    },
    {
      icon: <FiTrendingUp className="w-6 h-6" />,
      label: "99.9% Uptime Guarantee",
    },
  ];

  const containerVariants = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: {
        staggerChildren: 0.15,
      },
    },
  };

  const itemVariants = {
    hidden: { opacity: 0, y: 15 },
    visible: {
      opacity: 1,
      y: 0,
      transition: { duration: 0.5, ease: "easeOut" },
    },
  };

  return (
    <section className="py-24 bg-white relative overflow-hidden">
      <Container className={`bg-[#F8FAFC]  p-6 rounded-2xl `}>
        <motion.div
          initial={{ opacity: 0 }}
          whileInView={{ opacity: 1 }}
          viewport={{ once: false }}
          className="text-center mb-16"
        >
          <h3 className="text-[#0F172B] font-extrabold text-[13px] tracking-[0.25em] uppercase opacity-90">
            Why Farms Trust Us
          </h3>
        </motion.div>

        <div className="relative max-w-6xl mx-auto">
          <motion.div
            variants={containerVariants}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: false }}
            className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-12 relative z-10"
          >
            {trustItems.map((item, index) => (
              <motion.div
                key={index}
                variants={itemVariants}
                className="flex flex-col items-center text-center px-4"
              >
                <div className="w-16 h-16 rounded-full bg-white border border-[#E5E7EB]/50 shadow-[0_4px_20px_rgba(0,0,0,0.03)] flex items-center justify-center text-[#45556C] mb-8 hover:text-[#3B82F6] hover:border-[#3B82F6]/20 transition-all duration-500">
                  {item.icon}
                </div>
                <p className="text-[#45556C] font-semibold text-[15px] lg:text-[17px] leading-relaxed max-w-[200px]">
                  {item.label}
                </p>
              </motion.div>
            ))}
          </motion.div>
        </div>
      </Container>
    </section>
  );
};

export default TrustPart;
