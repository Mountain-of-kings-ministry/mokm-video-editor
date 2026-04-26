import { ArrowRight } from "lucide-react";

export default function Hero() {
  return (
    <section className="relative min-h-[98vh] flex items-center justify-center overflow-hidden">
      {/* Animated gradient background */}
      <div className="absolute inset-0 bg-[var(--color-surface)] dark:bg-[var(--color-surface-dark)]">
        <div className="absolute top-0 left-1/4 w-96 h-96 bg-[var(--color-primary)]/10 dark:bg-[var(--color-primary-dark)]/10 rounded-full blur-[120px] animate-pulse" />
        <div
          className="absolute bottom-0 right-1/4 w-80 h-80 bg-[var(--color-secondary)]/10 dark:bg-[var(--color-secondary-dark)]/10 rounded-full blur-[100px] animate-pulse"
          style={{ animationDelay: "1s" }}
        />
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] bg-[var(--color-accent)]/5 dark:bg-[var(--color-accent-dark)]/5 rounded-full blur-[150px]" />
      </div>

      {/* Grid pattern overlay */}
      <div
        className="absolute inset-0 opacity-[0.03] dark:opacity-[0.05]"
        style={{
          backgroundImage: `linear-gradient(var(--color-border) 1px, transparent 1px), linear-gradient(90deg, var(--color-border) 1px, transparent 1px)`,
          backgroundSize: "60px 60px",
        }}
      />

      <div className="relative z-10 max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        {/* Badge */}
        <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full border border-[var(--color-primary)]/30 dark:border-[var(--color-primary-dark)]/30 bg-[var(--color-primary)]/5 dark:bg-[var(--color-primary-dark)]/5 mb-8">
          <span className="relative flex h-2.5 w-2.5">
            <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-[var(--color-primary)] dark:bg-[var(--color-primary-dark)] opacity-75" />
            <span className="relative inline-flex rounded-full h-2.5 w-2.5 bg-[var(--color-primary)] dark:bg-[var(--color-primary-dark)]" />
          </span>
          <span className="text-sm font-medium text-[var(--color-primary)] dark:text-[var(--color-primary-dark)]">
            Open Source &mdash; Now in Active Development
          </span>
        </div>

        {/* Headline */}
        <h1 className="text-5xl sm:text-6xl lg:text-7xl font-extrabold tracking-tight text-[var(--color-text)] dark:text-[var(--color-text-dark)] leading-[1.1] mb-6">
          Professional Video Editing{" "}
          <span className="text-[var(--color-primary)] dark:text-[var(--color-primary-dark)]">
            Without
          </span>{" "}
          the Hardware Tax
        </h1>

        {/* Subheadline */}
        <p className="text-lg sm:text-xl text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)] max-w-3xl mx-auto mb-10 leading-relaxed">
          A node-based, open-source NLE built in C++ and Qt 6. Cinema-grade
          compositing, intelligent proxy workflows, and plugin extensibility
          &mdash; running smoothly even on 10-year-old laptops.
        </p>

        {/* CTAs */}
        <div className="flex flex-col sm:flex-row items-center justify-center gap-4 mb-16">
          <a
            href="#features"
            className="group inline-flex items-center gap-2 px-8 py-4 rounded-xl text-base font-semibold bg-[var(--color-primary)] dark:bg-[var(--color-primary-dark)] text-[var(--color-text-inverse)] dark:text-[var(--color-text-inverse-dark)] hover:brightness-110 transition-all shadow-[0_0_30px_var(--color-glow)] dark:shadow-[0_0_30px_var(--color-glow-dark)]"
          >
            Explore Features
            <ArrowRight className="w-5 h-5 transition-transform group-hover:translate-x-1" />
          </a>
          <a
            href="https://github.com/Mountain-of-kings-ministry/mokm-video-editor"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 px-8 py-4 rounded-xl text-base font-semibold border-2 border-[var(--color-border)] dark:border-[var(--color-border-dark)] text-[var(--color-text)] dark:text-[var(--color-text-dark)] hover:border-[var(--color-primary)] dark:hover:border-[var(--color-primary-dark)] hover:text-[var(--color-primary)] dark:hover:text-[var(--color-primary-dark)] transition-colors"
          >
            <svg
              className="w-5 h-5"
              fill="currentColor"
              viewBox="0 0 24 24"
              aria-hidden="true"
            >
              <path
                fillRule="evenodd"
                d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"
                clipRule="evenodd"
              />
            </svg>
            View on GitHub
          </a>
        </div>

        {/* Quick stats */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-6 max-w-3xl mx-auto">
          {[
            { value: "C++20", label: "Core Engine" },
            { value: "Qt 6.5+", label: "UI Framework" },
            { value: "GPLv3", label: "License" },
            { value: "Cross-Platform", label: "Win / Mac / Linux" },
          ].map((stat) => (
            <div
              key={stat.label}
              className="p-4 rounded-xl bg-[var(--color-panel)]/50 dark:bg-[var(--color-panel-dark)]/50 border border-[var(--color-border)] dark:border-[var(--color-border-dark)] backdrop-blur-sm"
            >
              <div className="text-xl sm:text-2xl font-bold text-[var(--color-primary)] dark:text-[var(--color-primary-dark)]">
                {stat.value}
              </div>
              <div className="text-xs sm:text-sm text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)] mt-1">
                {stat.label}
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Scroll indicator */}
      {/* <div className="absolute bottom-8 left-1/2 -translate-x-1/2 flex flex-col items-center gap-2 text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)] animate-bounce">
        <span className="text-xs uppercase tracking-widest">Scroll</span>
        <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 14l-7 7m0 0l-7-7m7 7V3" />
        </svg>
      </div> */}
    </section>
  );
}
