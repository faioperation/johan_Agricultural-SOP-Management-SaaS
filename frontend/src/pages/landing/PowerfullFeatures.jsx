import React from "react";
import Container from "../../components/Container";
import { FiFileText, FiWifiOff } from "react-icons/fi";
import { FaTasks } from "react-icons/fa";
import { IoChatbubbleOutline } from "react-icons/io5";
import { RiTaskFill } from "react-icons/ri";
import { LuShieldCheck } from "react-icons/lu";
import { motion } from "framer-motion";

const PowerfullFeature = () => {
  const containerVariants = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: {
        staggerChildren: 0.1,
      },
    },
  };

  const itemVariants = {
    hidden: { opacity: 0, scale: 0.95, y: 20 },
    visible: {
      opacity: 1,
      scale: 1,
      y: 0,
      transition: { duration: 0.5, ease: "easeOut" },
    },
  };

  const features = [
    {
      icon: <FiFileText className="w-6 h-6 text-[#F6A62D] " />,
      title: "SOP Management",
      description:
        "Centralize all your PDF procedures. Version control ensures everyone sees the latest update.",
    },
    {
      icon: <FiWifiOff className="w-6 h-6 text-[#F6A62D] " />,
      title: "Offline Access",
      description:
        "The mobile app works perfectly without internet. Data syncs automatically when connection returns.",
    },
    {
      icon: <FaTasks className="w-6 h-6 text-[#F6A62D] " />,
      title: "Task Checklists",
      description:
        "Convert SOPs into actionable daily checklists. Track completion in real-time.",
    },
    {
      icon: <IoChatbubbleOutline className="w-6 h-6 text-[#F6A62D] " />,
      title: "Team Messaging",
      description:
        "Built-in chat for teams to discuss tasks, share photos of issues, and stay connected.",
    },
    {
      icon: <LuShieldCheck className="w-6 h-6 text-[#F6A62D] " />,
      title: "Role-based Access",
      description:
        "Control what each employee can see and do. Managers get full oversight, workers see their tasks.",
    },
    {
      icon: <RiTaskFill className="w-6 h-6 text-[#F6A62D] " />,
      title: "Real time task Tracking",
      description:
        "Monitor task progress across your farm. See what’s completed, pending, or need attention",
    },
  ];

  return (
    <div className="pb-16">
      <Container className="bg-[#F8FAFC] py-12 px-6 rounded-3xl">
        <motion.div
          initial={{ opacity: 0, y: -20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: false }}
          transition={{ duration: 0.6 }}
        >
          <h3 className="text-4xl font-bold text-center">
            Powerful features, simple interface
          </h3>
          <p className="text-lg text-[#90A1B9] mt-4 text-center max-w-2xl mx-auto">
            Every feature is designed with the farm worker in mind, focusing on
            simplicity and utility.
          </p>
        </motion.div>

        <motion.div
          variants={containerVariants}
          initial="hidden"
          whileInView="visible"
          viewport={{ once: false, margin: "-50px" }}
          className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mt-16 px-5"
        >
          {features.map((feature, index) => (
            <motion.div
              key={index}
              variants={itemVariants}
              whileHover={{
                y: -10,
                boxShadow:
                  "0 20px 25px -5px rgba(0, 0, 0, 0.05), 0 10px 10px -5px rgba(0, 0, 0, 0.02)",
              }}
              className="bg-white border border-[#F1F5F9] rounded-2xl py-8 px-6 transition-all duration-300"
            >
              <div className="bg-[#FFF7ED] h-12 w-12 flex items-center justify-center rounded-xl mb-6">
                {feature.icon}
              </div>

              <h4 className="text-[#0F172B] text-xl font-bold mb-4">
                {feature.title}
              </h4>
              <p className="text-[#45556C] leading-relaxed">
                {feature.description}
              </p>
            </motion.div>
          ))}
        </motion.div>
      </Container>
    </div>
  );
};

export default PowerfullFeature;
