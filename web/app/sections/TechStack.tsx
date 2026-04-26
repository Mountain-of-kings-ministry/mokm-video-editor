const technologies = [
  { name: "C++20", category: "Language" },
  { name: "Qt 6.5+", category: "UI Framework" },
  { name: "FFmpeg", category: "Multimedia" },
  { name: "OpenColorIO", category: "Color" },
  { name: "OpenTimelineIO", category: "Interchange" },
  { name: "OpenCV", category: "Vision" },
  { name: "GLSL", category: "Shaders" },
  { name: "CMake", category: "Build" },
  { name: "OpenFX", category: "Plugins" },
  { name: "VST3", category: "Audio" },
  { name: "LV2", category: "Audio" },
  { name: "CLAP", category: "Audio" },
  { name: "Vulkan", category: "Graphics" },
  { name: "Metal", category: "Graphics" },
  { name: "Direct3D", category: "Graphics" },
  { name: "SQLite", category: "Database" },
];

export default function TechStack() {
  return (
    <section id="tech" className="py-24 sm:py-32">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <h2 className="text-3xl sm:text-4xl font-bold text-[var(--color-text)] dark:text-[var(--color-text-dark)] mb-4">
            Built on Proven{" "}
            <span className="text-[var(--color-primary)] dark:text-[var(--color-primary-dark)]">
              Open-Source Foundations
            </span>
          </h2>
          <p className="text-lg text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)]">
            No reinventing the wheel. MOKM integrates industry-standard libraries to deliver professional results.
          </p>
        </div>

        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
          {technologies.map((tech) => (
            <div
              key={tech.name}
              className="group relative p-4 rounded-xl bg-[var(--color-panel)]/30 dark:bg-[var(--color-panel-dark)]/30 border border-[var(--color-border)] dark:border-[var(--color-border-dark)] hover:border-[var(--color-primary)]/40 dark:hover:border-[var(--color-primary-dark)]/40 transition-all text-center"
            >
              <div className="text-base font-semibold text-[var(--color-text)] dark:text-[var(--color-text-dark)] group-hover:text-[var(--color-primary)] dark:group-hover:text-[var(--color-primary-dark)] transition-colors">
                {tech.name}
              </div>
              <div className="text-xs text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)] mt-1 uppercase tracking-wider">
                {tech.category}
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

