import { Clapperboard, Heart } from "lucide-react";

export default function Footer() {
  return (
    <footer className="border-t border-[var(--color-border)] dark:border-[var(--color-border-dark)] bg-[var(--color-panel)]/20 dark:bg-[var(--color-panel-dark)]/20">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="flex flex-col md:flex-row items-center justify-between gap-6">
          {/* Logo & tagline */}
          <div className="flex items-center gap-2">
            <Clapperboard className="w-6 h-6 text-[var(--color-primary)] dark:text-[var(--color-primary-dark)]" />
            <span className="text-lg font-bold text-[var(--color-text)] dark:text-[var(--color-text-dark)]">
              MOKM
            </span>
          </div>

          {/* Links */}
          <div className="flex items-center gap-6 text-sm text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)]">
            <a href="#features" className="hover:text-[var(--color-primary)] dark:hover:text-[var(--color-primary-dark)] transition-colors">
              Features
            </a>
            <a href="#proxy" className="hover:text-[var(--color-primary)] dark:hover:text-[var(--color-primary-dark)] transition-colors">
              Proxy Workflow
            </a>
            <a href="#tech" className="hover:text-[var(--color-primary)] dark:hover:text-[var(--color-primary-dark)] transition-colors">
              Tech Stack
            </a>
            <a href="#roadmap" className="hover:text-[var(--color-primary)] dark:hover:text-[var(--color-primary-dark)] transition-colors">
              Roadmap
            </a>
          </div>

          {/* License */}
          <div className="flex items-center gap-1 text-sm text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)]">
            <span>Licensed under</span>
            <a
              href="https://www.gnu.org/licenses/gpl-3.0.html"
              target="_blank"
              rel="noopener noreferrer"
              className="font-medium text-[var(--color-primary)] dark:text-[var(--color-primary-dark)] hover:underline"
            >
              GPLv3
            </a>
          </div>
        </div>

        <div className="mt-8 pt-8 border-t border-[var(--color-border)] dark:border-[var(--color-border-dark)] text-center text-sm text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)]">
          <p className="flex items-center justify-center gap-1">
            Built with <Heart className="w-4 h-4 text-red-500 fill-red-500" /> for the open-source community.
          </p>
          <p className="mt-1">
            &copy; {new Date().getFullYear()} MOKM Video Editor. All rights reserved.
          </p>
        </div>
      </div>
    </footer>
  );
}

