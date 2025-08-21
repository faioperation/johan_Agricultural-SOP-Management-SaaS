import React from 'react'
import { Link } from 'react-router-dom'
import { motion } from 'framer-motion'
import Container from '../Container'
import Image from '../Image'
import logo from "/logo.png"

const fadeUp = {
  hidden: { opacity: 0, y: 40 },
  visible: (i = 0) => ({
    opacity: 1,
    y: 0,
    transition: { duration: 0.6, delay: i * 0.15, ease: 'easeOut' },
  }),
}

const listVariants = {
  hidden: {},
  visible: { transition: { staggerChildren: 0.1 } },
}

const listItem = {
  hidden: { opacity: 0, x: -10 },
  visible: { opacity: 1, x: 0, transition: { duration: 0.4 } },
}

const Footer = () => {
  return (
    <div className='bg-[#0F172B]'>
      <Container className={`py-12 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-10`}>

        {/* Brand column */}
        <motion.div
          variants={fadeUp}
          initial="hidden"
          whileInView="visible"
          viewport={{ once: false }}
          custom={0}
        >
          <div className='flex items-center gap-2'>
            <Image src={logo} alt="FarmSOP Logo" className="w-8 h-8" />
            <p className='text-white font-bold text-xl'>FarmCheck</p>
          </div>

          <p className='text-[#90A1B9] mt-4'>
            Empowering farms with simple tools for better management and communication.
          </p>
        </motion.div>

        {/* Product column */}
        <motion.div
          variants={fadeUp}
          initial="hidden"
          whileInView="visible"
          viewport={{ once: false }}
          custom={1}
        >
          <h4 className='text-white font-semibold text-lg mb-4'>Product</h4>
          <motion.ul className='space-y-2' variants={listVariants} initial="hidden" whileInView="visible" viewport={{ once: false }}>
            <motion.li variants={listItem}><a href="#feature" className='text-[#90A1B9] hover:text-white transition-colors'>Features</a></motion.li>
            <motion.li variants={listItem}><a href="#pricing" className='text-[#90A1B9] hover:text-white transition-colors'>Pricing</a></motion.li>
          </motion.ul>
        </motion.div>

        {/* Company column */}
        <motion.div
          variants={fadeUp}
          initial="hidden"
          whileInView="visible"
          viewport={{ once: false }}
          custom={2}
        >
          <h4 className='text-white font-semibold text-lg mb-4'>Company</h4>
          <motion.ul className='space-y-2' variants={listVariants} initial="hidden" whileInView="visible" viewport={{ once: false }}>
            <motion.li variants={listItem}><Link to="/about-us" className='text-[#90A1B9] hover:text-white transition-colors'>About Us</Link></motion.li>
            <motion.li variants={listItem}><a href="#contact" className='text-[#90A1B9] hover:text-white transition-colors'>Contact</a></motion.li>
          </motion.ul>
        </motion.div>

        {/* Legal column */}
        <motion.div
          variants={fadeUp}
          initial="hidden"
          whileInView="visible"
          viewport={{ once: false }}
          custom={3}
        >
          <h4 className='text-white font-semibold text-lg mb-4'>Legal</h4>
          <motion.ul className='space-y-2' variants={listVariants} initial="hidden" whileInView="visible" viewport={{ once: false }}>
            <motion.li variants={listItem}><Link to="/privacy-policy" className='text-[#90A1B9] hover:text-white transition-colors'>Privacy Policy</Link></motion.li>
            <motion.li variants={listItem}><Link to="/terms-of-service" className='text-[#90A1B9] hover:text-white transition-colors'>Terms of Service</Link></motion.li>
          </motion.ul>
        </motion.div>

      </Container>

      {/* Copyright bar */}
      <motion.p
        className='text-[#62748E] text-center py-10 border-t border-[#1D293D]'
        initial={{ opacity: 0 }}
        whileInView={{ opacity: 1 }}
        viewport={{ once: false }}
        transition={{ duration: 0.8, delay: 0.4 }}
      >
        &copy; {new Date().getFullYear()} FarmSOP Inc. All rights reserved.
      </motion.p>
    </div>
  )
}

export default Footer
