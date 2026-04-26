import { Network, Film, Plug, Layers, Palette, ScanEye, Cpu, Monitor } from "lucide-react";

const features = [
  {
    icon: Network,
    title: "Node-Based Compositing",
    description:
      "Directed Acyclic Graph (DAG) with pull-based lazy evaluation. Build complex composites with GLSL shader nodes, ROI optimization, and transparent proxy/original switching.",
  },
  {
    icon: Film,
    title: "Proxy-First Editing",
    description:
      "Automatic background transcoding on import. Edit 4K footage smoothly on decade-old hardware using ProRes Proxy or H.264 I-frame proxies.",
  },
  {
    icon: Plug,
    title: "Plugin Extensibility",
    description:
      "Host OpenFX (OFX) video effects, VST3 / LV2 / CLAP audio processors, and Frei0r lightweight filters. Build custom nodes with C++.",
  },
  {
    icon: Layers,
    title: "Multi-Track Timeline",
    description:
      "Independent audio and video tracks with frame-accurate cutting, trimming, and razor tools. Custom C++ render node for 60 FPS timeline scrubbing.",
  },
  {
    icon: Palette,
    title: "HDR & Color Grading",
    description:
      "10-bit / 12-bit HDR workflows with OpenColorIO (OCIO) and ACES color management. Real-time vectorscopes, waveform monitors, and LUT support.",
  },
  {
    icon: ScanEye,
    title: "Motion Tracking",
    description:
      "Planar and point tracking powered by OpenCV. Pin elements to moving video with precise rotoscoping and masking tools.",
  },
  {
    icon: Cpu,
    title: "Hardware Acceleration",
    description:
      "NVENC, QuickSync, and VAAPI decoding/encoding. Zero-copy GPU pipelines and SIMD optimizations (SSE/AVX/NEON) for maximum performance.",
  },
  {
    icon: Monitor,
    title: "Cross-Platform",
    description:
      "Native builds for Windows, macOS, and Linux using Qt 6 RHI (Vulkan/Metal/Direct3D). One codebase, professional performance everywhere.",
  },
];

export default function Features() {
  return (
    <section id="features" className="py-24 sm:py-32">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Section header */}
        <div className="text-center max-w-3xl mx-auto mb-16">
          <h2 className="text-3xl sm:text-4xl font-bold text-[var(--color-text)] dark:text-[var(--color-text-dark)] mb-4">
            Everything You Need for{" "}
            <span className="text-[var(--color-primary)] dark:text-[var(--color-primary-dark)]">
              Professional Post-Production
            </span>
          </h2>
          <p className="text-lg text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)]">
            From basic cuts to cinema-grade compositing, MOKM scales with your ambition.
          </p>
        </div>

        {/* Bento grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          {features.map((feature) => {
            const Icon = feature.icon;
            return (
              <div
                key={feature.title}
                className="group relative p-6 rounded-2xl bg-[var(--color-panel)]/40 dark:bg-[var(--color-panel-dark)]/40 border border-[var(--color-border)] dark:border-[var(--color-border-dark)] hover:border-[var(--color-primary)]/40 dark:hover:border-[var(--color-primary-dark)]/40 transition-all hover:shadow-[0_0_30px_var(--color-glow)] dark:hover:shadow-[0_0_30px_var(--color-glow-dark)]"
              >
                <div className="mb-4 inline-flex items-center justify-center w-12 h-12 rounded-xl bg-[var(--color-primary)]/10 dark:bg-[var(--color-primary-dark)]/10 text-[var(--color-primary)] dark:text-[var(--color-primary-dark)] group-hover:scale-110 transition-transform">
                  <Icon className="w-6 h-6" />
                </div>
                <h3 className="text-lg font-semibold text-[var(--color-text)] dark:text-[var(--color-text-dark)] mb-2">
                  {feature.title}
                </h3>
                <p className="text-sm text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)] leading-relaxed">
                  {feature.description}
                </p>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}

