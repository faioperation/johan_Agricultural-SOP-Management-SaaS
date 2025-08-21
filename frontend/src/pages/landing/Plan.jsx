import React from 'react';
import { useNavigate } from 'react-router-dom';
import useAxiosPublic from '../../hooks/useAxiosPublic';
import { useQuery } from '@tanstack/react-query';
import PlanComponent from '../../components/Plan';
import Container from '../../components/Container';
import { motion } from 'framer-motion';

const Plan = () => {
  const axiosPublic = useAxiosPublic();
  const navigate = useNavigate();

  // GET PLANS API (Public)
  const { data: plansData = [], isLoading: plansLoading } = useQuery({
    queryKey: ["publicSubscriptionPlansAll"],
    queryFn: async () => {
      const res = await axiosPublic.get("/system-owner/plan/all");
      // Check if data is nested under 'plans' or is the data itself
      const rawData = res.data.data;
      if (Array.isArray(rawData)) return rawData;
      if (rawData && Array.isArray(rawData.plans)) return rawData.plans;
      return [];
    },
  });

  const plans = Array.isArray(plansData) ? plansData : [];

  const handleSubscribe = () => {
    navigate("/owner/subscription/plans");
  };

  if (plansLoading) {
    return (
      <div className="py-20 text-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#F6A62D] mx-auto"></div>
        <p className="mt-4 text-slate-600">Loading plans...</p>
      </div>
    );
  }

  return (
    <div id="pricing" className="py-20 bg-white">
      <Container>
        <motion.div
           initial={{ opacity: 0, y: 20 }}
           whileInView={{ opacity: 1, y: 0 }}
           viewport={{ once: false }}
           transition={{ duration: 0.6 }}
           className="text-center mb-12"
        >
          <h2 className="text-3xl md:text-5xl font-bold text-[#0F172B]">
            Simple pricing for farms of all sizes
          </h2>
          <p className="text-[#90A1B9] text-lg mt-4 max-w-2xl mx-auto">
            Pay based on the size of your team. No hidden fees.
          </p>
        </motion.div>

        <PlanComponent
          plans={plans}
          onSubscribe={handleSubscribe}
        />
      </Container>
    </div>
  );
};

export default Plan;
