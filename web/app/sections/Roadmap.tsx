import { CheckCircle2, Circle, Timer } from "lucide-react";

const phases = [
  {
    phase: "Phase 1",
    title: "Foundation",
    status: "in-progress",
    items: ["CMake + Qt 6 project setup", "FFmpeg decoding pipeline", "Basic playback & seeking", "Proxy generation core"],
  },
  {
    phase: "Phase 2",
    title: "Core Editing",
    status: "planned",
    items: ["Multi-track timeline", "Cut/trim/razor tools", "Basic transitions", "Asset bin management", "Undo/redo + auto-save"],
  },
  {
    phase: "Phase 3",
    title: "Node Engine",
    status: "planned",
    items: ["DAG node graph", "GLSL shader framework", "Transform & blend nodes", "Basic compositing"],
  },
  {
    phase: "Phase 4",
    title: "Intermediate Features",
    status: "planned",
    items: ["Keyframe animation (Bezier)", "Color correction tools", "Audio mixing & EQ", "Custom LUT support"],
  },
  {
    phase: "Phase 5",
    title: "Professional Tier",
    status: "planned",
    items: ["Advanced compositing & masking", "Motion tracking (OpenCV)", "HDR & OCIO color grading", "OFX / VST3 / LV2 plugin hosting", "OTIO interchange"],
  },
  {
    phase: "Phase 6",
    title: "Polish & Optimization",
    status: "planned",
    items: ["Low-end hardware tuning", "UI/UX refinement", "Crash recovery", "Documentation & community"],
  },
];

export default function Roadmap() {
  return (
    <section id="roadmap" className="py-24 sm:py-32">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-3xl sm:text-4xl font-bold text-[var(--color-text)] dark:text-[var(--color-text-dark)] mb-4">
            Development{" "}
            <span className="text-[var(--color-primary)] dark:text-[var(--color-primary-dark)]">
              Roadmap
            </span>
          </h2>
          <p className="text-lg text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)]">
            A phased approach to building a professional-grade open-source NLE.
          </p>
        </div>

        <div className="relative">
          {/* Vertical line */}
          <div className="absolute left-6 sm:left-8 top-0 bottom-0 w-px bg-[var(--color-border)] dark:bg-[var(--color-border-dark)]" />

          <div className="space-y-10">
            {phases.map((phase) => {
              const isDone = phase.status === "done";
              const isInProgress = phase.status === "in-progress";

              return (
                <div key={phase.phase} className="relative flex gap-6 sm:gap-8">
                  {/* Timeline dot */}
                  <div className="flex-shrink-0 relative z-10">
                    <div
                      className={`w-12 h-12 sm:w-16 sm:h-16 rounded-full flex items-center justify-center border-2 ${
                        isDone
                          ? "bg-[var(--color-primary)] dark:bg-[var(--color-primary-dark)] border-[var(--color-primary)] dark:border-[var(--color-primary-dark)]"
                          : isInProgress
                          ? "bg-[var(--color-primary)]/10 dark:bg-[var(--color-primary-dark)]/10 border-[var(--color-primary)] dark:border-[var(--color-primary-dark)]"
                          : "bg-[var(--color-panel)] dark:bg-[var(--color-panel-dark)] border-[var(--color-border)] dark:border-[var(--color-border-dark)]"
                      }`}
                    >
                      {isDone ? (
                        <CheckCircle2 className="w-6 h-6 sm:w-8 sm:h-8 text-[var(--color-text-inverse)] dark:text-[var(--color-text-inverse-dark)]" />
                      ) : isInProgress ? (
                        <Timer className="w-6 h-6 sm:w-8 sm:h-8 text-[var(--color-primary)] dark:text-[var(--color-primary-dark)]" />
                      ) : (
                        <Circle className="w-6 h-6 sm:w-8 sm:h-8 text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)]" />
                      )}
                    </div>
                  </div>

                  {/* Content */}
                  <div className="flex-1 pt-2 sm:pt-3">
                    <div className="flex items-center gap-3 mb-2">
                      <span className="text-sm font-medium text-[var(--color-primary)] dark:text-[var(--color-primary-dark)] uppercase tracking-wider">
                        {phase.phase}
                      </span>
                      {isInProgress && (
                        <span className="px-2 py-0.5 rounded-full text-xs font-medium bg-[var(--color-primary)]/10 dark:bg-[var(--color-primary-dark)]/10 text-[var(--color-primary)] dark:text-[var(--color-primary-dark)]">
                          In Progress
                        </span>
                      )}
                    </div>
                    <h3 className="text-xl sm:text-2xl font-bold text-[var(--color-text)] dark:text-[var(--color-text-dark)] mb-3">
                      {phase.title}
                    </h3>
                    <ul className="space-y-2">
                      {phase.items.map((item) => (
                        <li
                          key={item}
                          className="flex items-start gap-2 text-sm sm:text-base text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)]"
                        >
                          <span className="mt-1.5 w-1.5 h-1.5 rounded-full bg-[var(--color-primary)]/50 dark:bg-[var(--color-primary-dark)]/50 flex-shrink-0" />
                          {item}
                        </li>
                      ))}
                    </ul>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </section>
  );
}

