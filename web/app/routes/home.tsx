import type { Route } from "./+types/home";
import Navbar from "../sections/Navbar";
import Hero from "../sections/Hero";
import Features from "../sections/Features";
import ProxyHighlight from "../sections/ProxyHighlight";
import TechStack from "../sections/TechStack";
import Roadmap from "../sections/Roadmap";
import Footer from "../sections/Footer";

export function meta({}: Route.MetaArgs) {
  return [
    { title: "MOKM Video Editor — Professional Node-Based NLE" },
    { name: "description", content: "An open-source, node-based video editor built in C++ and Qt 6. Cinema-grade compositing, intelligent proxy workflows, and plugin extensibility — running smoothly even on low-end hardware." },
    { name: "keywords", content: "video editor, open source, NLE, node-based, C++, Qt, FFmpeg, proxy editing, color grading, motion tracking" },
    { property: "og:title", content: "MOKM Video Editor — Professional Node-Based NLE" },
    { property: "og:description", content: "An open-source, node-based video editor built in C++ and Qt 6. Cinema-grade compositing, intelligent proxy workflows, and plugin extensibility." },
    { property: "og:type", content: "website" },
    { name: "twitter:card", content: "summary_large_image" },
    { name: "twitter:title", content: "MOKM Video Editor — Professional Node-Based NLE" },
    { name: "twitter:description", content: "An open-source, node-based video editor built in C++ and Qt 6. Cinema-grade compositing, intelligent proxy workflows, and plugin extensibility." },
  ];
}

export default function Home() {
  return (
    <div className="min-h-screen bg-[var(--color-surface)] dark:bg-[var(--color-surface-dark)]">
      <Navbar />
      <main>
        <Hero />
        <Features />
        <ProxyHighlight />
        <TechStack />
        <Roadmap />
      </main>
      <Footer />
    </div>
  );
}

