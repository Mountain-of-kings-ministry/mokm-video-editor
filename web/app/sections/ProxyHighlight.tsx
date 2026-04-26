import { ArrowDownToLine, Zap, RefreshCw, ShieldCheck } from "lucide-react";

const steps = [
  {
    icon: ArrowDownToLine,
    title: "Import",
    desc: "Drop 4K/8K footage into the project. MOKM analyzes hardware capabilities automatically.",
  },
  {
    icon: Zap,
    title: "Transcode",
    desc: "Background proxy generation kicks in using FFmpeg. I-frame only codecs for instant scrubbing.",
  },
  {
    icon: RefreshCw,
    title: "Edit Seamlessly",
    desc: "The timeline pulls from low-res proxies. Toggle 'High Quality Preview' anytime for original sources.",
  },
  {
    icon: ShieldCheck,
    title: "Render Final",
    desc: "Export always uses original full-resolution media. Deterministic, bit-identical output across machines.",
  },
];

const comparisons = [
  { label: "Source", res: "4K 10-bit", codec: "H.265", status: "Stutters on old hardware" },
  { label: "Proxy", res: "720p 8-bit", codec: "ProRes Proxy", status: "Silky smooth playback" },
];

export default function ProxyHighlight() {
  return (
    <section id="proxy" className="py-24 sm:py-32 relative overflow-hidden">
      {/* Background glow */}
      <div className="absolute inset-0 bg-[var(--color-base)] dark:bg-[var(--color-base-dark)]">
        <div className="absolute top-1/2 left-0 w-[500px] h-[500px] bg-[var(--color-primary)]/5 dark:bg-[var(--color-primary-dark)]/5 rounded-full blur-[120px] -translate-y-1/2" />
      </div>

      <div className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid lg:grid-cols-2 gap-16 items-center">
          {/* Left: Content */}
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[var(--color-primary)]/10 dark:bg-[var(--color-primary-dark)]/10 text-[var(--color-primary)] dark:text-[var(--color-primary-dark)] text-sm font-medium mb-6">
              <Zap className="w-4 h-4" />
              Core Innovation
            </div>
            <h2 className="text-3xl sm:text-4xl font-bold text-[var(--color-text)] dark:text-[var(--color-text-dark)] mb-6">
              Edit 4K on a{" "}
              <span className="text-[var(--color-primary)] dark:text-[var(--color-primary-dark)]">
                10-Year-Old Laptop
              </span>
            </h2>
            <p className="text-lg text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)] mb-10 leading-relaxed">
              MOKM&apos;s proxy-first architecture is not a feature &mdash; it is a core philosophy.
              Every asset can be proxied. The editor maintains dual pointers to proxy and original
              sources, swapping transparently based on context.
            </p>

            {/* Comparison cards */}
            <div className="space-y-3 mb-10">
              {comparisons.map((comp) => (
                <div
                  key={comp.label}
                  className="flex items-center gap-4 p-4 rounded-xl border border-[var(--color-border)] dark:border-[var(--color-border-dark)] bg-[var(--color-panel)]/30 dark:bg-[var(--color-panel-dark)]/30"
                >
                  <div className={`w-2 h-2 rounded-full ${comp.label === "Proxy" ? "bg-green-500" : "bg-red-500"}`} />
                  <div className="flex-1 grid grid-cols-3 gap-4 text-sm">
                    <div>
                      <span className="text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)] text-xs uppercase tracking-wider">Type</span>
                      <p className="font-semibold text-[var(--color-text)] dark:text-[var(--color-text-dark)]">{comp.label}</p>
                    </div>
                    <div>
                      <span className="text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)] text-xs uppercase tracking-wider">Resolution</span>
                      <p className="font-semibold text-[var(--color-text)] dark:text-[var(--color-text-dark)]">{comp.res}</p>
                    </div>
                    <div>
                      <span className="text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)] text-xs uppercase tracking-wider">Codec</span>
                      <p className="font-semibold text-[var(--color-text)] dark:text-[var(--color-text-dark)]">{comp.codec}</p>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Right: Step flow */}
          <div className="space-y-6">
            {steps.map((step, idx) => {
              const Icon = step.icon;
              return (
                <div
                  key={step.title}
                  className="flex gap-5 p-5 rounded-2xl bg-[var(--color-panel)]/40 dark:bg-[var(--color-panel-dark)]/40 border border-[var(--color-border)] dark:border-[var(--color-border-dark)] hover:border-[var(--color-primary)]/30 dark:hover:border-[var(--color-primary-dark)]/30 transition-colors"
                >
                  <div className="flex-shrink-0">
                    <div className="w-12 h-12 rounded-xl bg-[var(--color-primary)]/10 dark:bg-[var(--color-primary-dark)]/10 flex items-center justify-center text-[var(--color-primary)] dark:text-[var(--color-primary-dark)] font-bold text-lg">
                      {idx + 1}
                    </div>
                  </div>
                  <div>
                    <div className="flex items-center gap-2 mb-1">
                      <Icon className="w-4 h-4 text-[var(--color-primary)] dark:text-[var(--color-primary-dark)]" />
                      <h3 className="text-lg font-semibold text-[var(--color-text)] dark:text-[var(--color-text-dark)]">
                        {step.title}
                      </h3>
                    </div>
                    <p className="text-sm text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)] leading-relaxed">
                      {step.desc}
                    </p>
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

