import React from "react";
import Container from "../../components/Container";
import Image from "../../components/Image";
import MobileView from "/MobileView.png";
import { FiWifiOff } from "react-icons/fi";
import { MdTranslate } from "react-icons/md";
import { CiMobile2 } from "react-icons/ci";
import { motion } from "framer-motion";

const AppFeature = () => {
  const listContainerVariants = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: {
        staggerChildren: 0.15,
        delayChildren: 0.3,
      },
    },
  };

  const listItemVariants = {
    hidden: { opacity: 0, x: 20 },
    visible: {
      opacity: 1,
      x: 0,
      transition: { duration: 0.5 },
    },
  };

  return (
    <div className="bg-[#0F172B] py-20 overflow-hidden">
      <Container>
        <div className="flex flex-col lg:flex-row gap-16 lg:gap-24 items-center">
          <motion.div
            initial={{ opacity: 0, x: -100 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: false }}
            transition={{ duration: 0.8, ease: "easeOut" }}
            className="w-full lg:w-1/2"
          >
            <motion.div
              animate={{
                y: [0, -15, 0],
              }}
              transition={{
                duration: 6,
                repeat: Infinity,
                ease: "easeInOut",
              }}
            >
              <Image
                src={MobileView}
                alt="Mobile 1"
                className="w-full h-auto drop-shadow-[0_35px_35px_rgba(0,0,0,0.5)]"
              />
            </motion.div>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, x: 100 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: false }}
            transition={{ duration: 0.8, ease: "easeOut" }}
            className="w-full lg:w-1/2"
          >
            <h3 className="font-bold text-white text-3xl lg:text-4xl leading-tight">
              Designed for the field, <br />
              not the office
            </h3>
            <p className="text-[#90A1B9] text-lg mt-6 leading-relaxed">
              Our app is designed to work seamlessly in the field, providing you
              with the tools you need to manage your agricultural operations
              efficiently. No training required.
            </p>

            <motion.div
              variants={listContainerVariants}
              initial="hidden"
              whileInView="visible"
              viewport={{ once: false }}
              className="space-y-8 mt-10"
            >
              {/* Benefit 1 */}
              <motion.div
                variants={listItemVariants}
                className="flex items-start gap-5 group"
              >
                <div className="border-[#90A1B9]/20 w-fit p-4 rounded-2xl border bg-[#1E293B] shadow-inner group-hover:bg-[#314158] transition-colors">
                  <FiWifiOff className="w-6 h-6 text-[#F6A62D]" />
                </div>

                <div>
                  <h4 className="text-white font-bold text-xl mb-1">
                    Zero-Lag Offline Mode
                  </h4>
                  <p className="text-[#90A1B9] text-base leading-relaxed">
                    Access your data anytime, anywhere, without an internet
                    connection. Syncs automatically.
                  </p>
                </div>
              </motion.div>

              {/* Benefit 2 */}
              <motion.div
                variants={listItemVariants}
                className="flex items-start gap-5 group"
              >
                <div className="border-[#90A1B9]/20 w-fit p-4 rounded-2xl border bg-[#1E293B] shadow-inner group-hover:bg-[#314158] transition-colors">
                  <MdTranslate className="w-6 h-6 text-[#F6A62D]" />
                </div>

                <div>
                  <h4 className="text-white font-bold text-xl mb-1">
                    Multilingual Support
                  </h4>
                  <p className="text-[#90A1B9] text-base leading-relaxed">
                    App interface and SOPs available in your team's native
                    language for better adoption.
                  </p>
                </div>
              </motion.div>

              {/* Benefit 3 */}
              <motion.div
                variants={listItemVariants}
                className="flex items-start gap-5 group"
              >
                <div className="border-[#90A1B9]/20 w-fit p-4 rounded-2xl border bg-[#1E293B] shadow-inner group-hover:bg-[#314158] transition-colors">
                  <CiMobile2 className="w-6 h-6 text-[#F6A62D]" />
                </div>

                <div>
                  <h4 className="text-white font-bold text-xl mb-1">
                    Simple UX
                  </h4>
                  <p className="text-[#90A1B9] text-base leading-relaxed">
                    Big buttons, clear text, and visual cues. Built specifically
                    for gloved hands and bright sun.
                  </p>
                </div>
              </motion.div>
            </motion.div>
          </motion.div>
        </div>
      </Container>
    </div>
  );
};

export default AppFeature;
