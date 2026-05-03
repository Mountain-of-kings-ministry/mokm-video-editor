import { useState } from "react";
import type { Route } from "./+types/home";
import Navbar from "../sections/Navbar";
import Sidebar from "../sections/Sidebar";
import Hero from "../sections/Hero";
import Features from "../sections/Features";
import TechStack from "../sections/TechStack";
import Roadmap from "../sections/Roadmap";
import { LayoutDashboard, Layers, Box, Settings } from "lucide-react";

export function meta({}: Route.MetaArgs) {
  return [
    { title: "MOKM Video Editor — Node-Based Open-Source NLE" },
    { name: "description", content: "An open-source, node-based video editor built in C++ and Qt 6. High-efficiency editing, procedural workflows, and native performance on all hardware." },
    { name: "keywords", content: "video editor, NLE, open source, node-based, C++, Qt, FFmpeg, procedural editing, video design" },
    { property: "og:title", content: "MOKM Video Editor — Node-Based Open-Source NLE" },
    { property: "og:description", content: "An open-source, node-based video editor built in C++ and Qt 6. High-efficiency editing and procedural workflows." },
    { property: "og:type", content: "website" },
    { name: "twitter:card", content: "summary_large_image" },
    { name: "twitter:title", content: "MOKM Video Editor — Node-Based Open-Source NLE" },
    { name: "twitter:description", content: "An open-source, node-based video editor built in C++ and Qt 6. High-efficiency editing and procedural workflows." },
  ];
}

type TabId = 'canvas' | 'bin' | 'timeline' | 'inspector';

export default function Home() {
  const [activeTab, setActiveTab] = useState<TabId>('canvas');

  return (
    <div className="flex flex-col h-[100dvh] bg-[var(--color-surface)] dark:bg-[var(--color-surface-dark)] text-[var(--color-text)] dark:text-[var(--color-text-dark)] overflow-hidden font-sans">
      <Navbar />
      
      <div className="flex flex-1 min-h-0 overflow-hidden relative">
        <div className="hidden md:flex">
          <Sidebar />
        </div>
        
        {/* Project Bin / Features */}
        <aside className={`${activeTab === 'bin' ? 'flex flex-1' : 'hidden'} md:block w-full md:w-64 border-r border-[var(--color-border)] dark:border-[var(--color-border-dark)] bg-[var(--color-base)] dark:bg-[var(--color-base-dark)] overflow-y-auto`}>
          <Features />
        </aside>

        <div className={`${activeTab === 'canvas' || activeTab === 'timeline' ? 'flex flex-1' : 'hidden md:flex'} md:flex-1 flex-col min-w-0`}>
          {/* Main Canvas / Hero */}
          <main className={`${activeTab === 'canvas' ? 'flex flex-1' : 'hidden md:block'} md:flex-1 relative overflow-hidden bg-[var(--color-panel)] dark:bg-[var(--color-panel-dark)]`}>
            <Hero />
          </main>

          {/* Timeline / Roadmap */}
          <section className={`${activeTab === 'timeline' ? 'flex flex-1 overflow-y-auto' : 'hidden md:block'} md:h-48 border-t border-[var(--color-border)] dark:border-[var(--color-border-dark)] bg-[var(--color-base)] dark:bg-[var(--color-base-dark)] md:overflow-x-auto`}>
            <Roadmap />
          </section>
        </div>

        {/* Inspector / Tech Stack */}
        <aside className={`${activeTab === 'inspector' ? 'flex flex-1' : 'hidden lg:block'} w-full lg:w-72 border-l border-[var(--color-border)] dark:border-[var(--color-border-dark)] bg-[var(--color-base)] dark:bg-[var(--color-base-dark)] overflow-y-auto`}>
          <TechStack />
        </aside>
      </div>

      {/* Mobile Tab Navigation */}
      <div className="md:hidden flex border-t border-[var(--color-border)] dark:border-[var(--color-border-dark)] bg-[var(--color-base)] dark:bg-[var(--color-base-dark)] h-14 pb-safe">
        {[
          { id: 'canvas', icon: LayoutDashboard, label: 'Canvas' },
          { id: 'bin', icon: Box, label: 'Bin' },
          { id: 'timeline', icon: Layers, label: 'Timeline' },
          { id: 'inspector', icon: Settings, label: 'Inspector' }
        ].map((tab) => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id as TabId)}
            className={`flex-1 flex flex-col items-center justify-center gap-1 ${
              activeTab === tab.id 
                ? 'text-[var(--color-primary)] dark:text-[var(--color-primary-dark)]' 
                : 'text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)] hover:bg-[var(--color-panel)] dark:hover:bg-[var(--color-panel-dark)]'
            } transition-colors`}
          >
            <tab.icon className="w-5 h-5" />
            <span className="text-[10px] font-medium">{tab.label}</span>
          </button>
        ))}
      </div>

      {/* Footer / Status Bar (Hidden on Mobile) */}
      <footer className="hidden md:flex h-6 border-t border-[var(--color-border)] dark:border-[var(--color-border-dark)] bg-[var(--color-panel)] dark:bg-[var(--color-panel-dark)] items-center justify-between px-3 text-[10px] text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)] select-none">
        <div className="flex items-center gap-4">
          <span>Ready</span>
          <span>Composition: Main_Render</span>
          <span>Frame: 0 / 240</span>
        </div>
        <div className="flex items-center gap-4">
          <span>Engine: FFmpeg</span>
          <span>GPU: Vulkan</span>
          <span>Memory: 42MB</span>
        </div>
      </footer>
    </div>
  );
}
