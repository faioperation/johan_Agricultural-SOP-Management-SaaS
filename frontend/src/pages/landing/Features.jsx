import React from "react";
import Container from "../../components/Container";
import { FiFileText } from "react-icons/fi";
import { LiaMobileSolid } from "react-icons/lia";
import { FaWifi } from "react-icons/fa";
import { MdOutlineChatBubbleOutline } from "react-icons/md";
import Image from "../../components/Image";
import progress from "/progress.png";
import progressContainer from "/ProgressContainer.png";
import { motion } from "framer-motion";

const Features = () => {
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
    hidden: { opacity: 0, y: 20 },
    visible: {
      opacity: 1,
      y: 0,
      transition: {
        duration: 0.5,
        ease: "easeOut",
      },
    },
  };

  return (
    <div id="feature" className="py-15">
      <Container
        className={`bg-[#0F172B] rounded-2xl flex flex-col lg:flex-row items-center justify-between overflow-hidden shadow-2xl`}
      >
        <motion.div
          initial={{ opacity: 0, x: -50 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: false }}
          transition={{ duration: 0.8 }}
          className="px-6 lg:px-10 py-12 lg:w-[50%]"
        >
          <motion.h3
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: false }}
            transition={{ delay: 0.2, duration: 0.6 }}
            className="text-white text-3xl lg:text-4xl font-bold leading-tight"
          >
            Everything you need to run your farm efficiently
          </motion.h3>
          <motion.p
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: false }}
            transition={{ delay: 0.3, duration: 0.6 }}
            className="text-lg text-[#90A1B9] my-6"
          >
            We bridge the gap between complex farm operations and simple
            execution. Give your team the tools they need to succeed, right in
            their pocket.
          </motion.p>

          <motion.div
            variants={containerVariants}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: false }}
            className="grid grid-cols-1 md:grid-cols-2 gap-8"
          >
            {/* Feature 1 */}
            <motion.div variants={itemVariants} className="flex gap-4 group">
              <div className="bg-[#F6A62D] rounded-xl h-12 w-12 flex-shrink-0 flex items-center justify-center transition-transform duration-300 group-hover:scale-110 group-hover:rotate-3 shadow-lg shadow-orange-500/20">
                <FiFileText className="w-6 h-6 text-white" />
              </div>
              <div>
                <p className="text-white font-bold text-lg mb-1">
                  Centralized SOPs
                </p>
                <p className="text-[#90A1B9] text-sm leading-relaxed">
                  Manage all your PDFs in one place. Ensure everyone has the
                  latest version.
                </p>
              </div>
            </motion.div>

            {/* Feature 2 */}
            <motion.div variants={itemVariants} className="flex gap-4 group">
              <div className="bg-[#F6A62D] rounded-xl h-12 w-12 flex-shrink-0 flex items-center justify-center transition-transform duration-300 group-hover:scale-110 group-hover:rotate-3 shadow-lg shadow-orange-500/20">
                <LiaMobileSolid className="w-6 h-6 text-white" />
              </div>
              <div>
                <p className="text-white font-bold text-lg mb-1">
                  Mobile First
                </p>
                <p className="text-[#90A1B9] text-sm leading-relaxed">
                  Designed for employees on the go. Simple interface for any
                  skill level.
                </p>
              </div>
            </motion.div>

            {/* Feature 3 */}
            <motion.div variants={itemVariants} className="flex gap-4 group">
              <div className="bg-[#F6A62D] rounded-xl h-12 w-12 flex-shrink-0 flex items-center justify-center transition-transform duration-300 group-hover:scale-110 group-hover:rotate-3 shadow-lg shadow-orange-500/20">
                <FaWifi className="w-6 h-6 text-white" />
              </div>
              <div>
                <p className="text-white font-bold text-lg mb-1">
                  Works Offline
                </p>
                <p className="text-[#90A1B9] text-sm leading-relaxed">
                  Full access to tasks and SOPs even without an internet
                  connection.
                </p>
              </div>
            </motion.div>

            {/* Feature 4 */}
            <motion.div variants={itemVariants} className="flex gap-4 group">
              <div className="bg-[#F6A62D] rounded-xl h-12 w-12 flex-shrink-0 flex items-center justify-center transition-transform duration-300 group-hover:scale-110 group-hover:rotate-3 shadow-lg shadow-orange-500/20">
                <MdOutlineChatBubbleOutline className="w-6 h-6 text-white" />
              </div>
              <div>
                <p className="text-white font-bold text-lg mb-1">Team Chat</p>
                <p className="text-[#90A1B9] text-sm leading-relaxed">
                  Keep communication focused and contextual within tasks.
                </p>
              </div>
            </motion.div>
          </motion.div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, x: 50 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: false }}
          transition={{ duration: 0.8, delay: 0.2 }}
          className="lg:w-[45%] relative mt-8 lg:mt-0"
        >
          <motion.div
            whileHover={{ scale: 1.02 }}
            transition={{ duration: 0.3 }}
            className="relative z-10"
          >
            <Image
              src={progress}
              alt="Features"
              className="w-full h-full object-contain shadow-2xl"
            />
          </motion.div>

          <motion.div
            animate={{
              y: [0, -10, 0],
            }}
            transition={{
              duration: 4,
              repeat: Infinity,
              ease: "easeInOut",
            }}
            className="absolute bottom-4 lg:bottom-8 left-4 lg:left-8 z-20 w-1/2 lg:w-auto"
          >
            <Image
              src={progressContainer}
              alt="progressContainer"
              className="drop-shadow-2xl"
            />
          </motion.div>
        </motion.div>
      </Container>
    </div>
  );
};

export default Features;
