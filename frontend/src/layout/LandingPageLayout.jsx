import React from "react";
import Navbar from "../components/layout/Navbar";
import Banner from "../pages/landing/Banner";
import Features from "../pages/landing/Features";
import SetupSteps from "../pages/landing/SetupSteps";
import PowerfullFeature from "../pages/landing/PowerfullFeatures";
import TrustPart from "../pages/landing/TrustPart";
import AppFeature from "../pages/landing/AppFeature";
import DownloadApp from "../pages/landing/DownloadApp";
import Plan from "../pages/landing/Plan";
import Contact from "../pages/landing/Contact";
import Footer from "../components/layout/Footer";

const LandingPageLayout = () => {
  return (
    <div className="pt-24">
      <Navbar />
      <Banner />
      <Features/>
      <SetupSteps/>
      <PowerfullFeature/>
      <TrustPart />
      <Plan />
      <AppFeature/>
      <Contact />
      <DownloadApp/>
      <Footer />
    </div>
  );
};

export default LandingPageLayout;
