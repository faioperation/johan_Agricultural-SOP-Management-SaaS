import React from "react";
import Container from "../../components/Container";
import { motion } from "framer-motion";

const SetupSteps = () => {
  const containerVariants = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: {
        staggerChildren: 0.2,
      },
    },
  };

  const itemVariants = {
    hidden: { opacity: 0, y: 30 },
    visible: {
      opacity: 1,
      y: 0,
      transition: { duration: 0.6, ease: "easeOut" },
    },
  };

  const steps = [
    {
      id: "01",
      title: "Create your farm",
      description: "Set up your farm profile and invite your management team.",
    },
    {
      id: "02",
      title: "Upload SOPs",
      description:
        "Upload your existing PDF procedures. We organize them for easy access.",
    },
    {
      id: "03",
      title: "Assign Tasks",
      description:
        "Create daily checklists and assign them to specific employees or roles.",
    },
    {
      id: "04",
      title: "Team Executes",
      description:
        "Employees follow SOPs on their mobile devices — even offline.",
    },
  ];

  return (
    <div className="pb-16">
      <Container className="bg-[#F8FAFC] py-12 px-6 rounded-3xl shadow-sm border border-slate-100">
        <motion.div
          initial={{ opacity: 0, y: -20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: false }}
          transition={{ duration: 0.6 }}
        >
          <h3 className="text-4xl font-bold text-center text-[#0F172B]">
            Simple setup, immediate impact
          </h3>
          <p className="text-lg text-[#90A1B9] mt-4 text-center max-w-2xl mx-auto">
            Get your farm running smoothly in four easy steps. Designed for
            quick adoption by your entire team.
          </p>
        </motion.div>

        <motion.div
          variants={containerVariants}
          initial="hidden"
          whileInView="visible"
          viewport={{ once: false, margin: "-100px" }}
          className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 mt-16"
        >
          {steps.map((step) => (
            <motion.div
              key={step.id}
              variants={itemVariants}
              whileHover={{ y: -10 }}
              className="text-center flex flex-col items-center group"
            >
              <motion.p
                whileHover={{ scale: 1.1, rotate: 5 }}
                className="bg-white rounded-2xl border-2 border-[#F6A62D] py-2 px-4 text-[#F6A62D] font-bold text-2xl w-fit shadow-md group-hover:shadow-[#F6A62D]/20 transition-all"
              >
                {step.id}
              </motion.p>

              <h4 className="text-[#0F172B] text-xl font-bold my-6 group-hover:text-[#F6A62D] transition-colors">
                {step.title}
              </h4>
              <p className="text-[#45556C] leading-relaxed">
                {step.description}
              </p>
            </motion.div>
          ))}
        </motion.div>
      </Container>
    </div>
  );
};

export default SetupSteps;
