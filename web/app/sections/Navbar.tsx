import { useState } from "react";
import { Menu, X, Clapperboard } from "lucide-react";

export default function Navbar() {
  const [isOpen, setIsOpen] = useState(false);

  const navLinks = [
    { label: "Features", href: "#features" },
    { label: "Proxy Workflow", href: "#proxy" },
    { label: "Tech Stack", href: "#tech" },
    { label: "Roadmap", href: "#roadmap" },
  ];

  return (
    <nav className="sticky top-0 z-50 backdrop-blur-md border-b border-[var(--color-border)] dark:border-[var(--color-border-dark)] bg-[var(--color-base)]/80 dark:bg-[var(--color-base-dark)]/80">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <a href="#" className="flex items-center gap-2 group">
            <Clapperboard className="w-7 h-7 text-[var(--color-primary)] dark:text-[var(--color-primary-dark)] transition-transform group-hover:rotate-12" />
            <span className="text-xl font-bold tracking-tight text-[var(--color-text)] dark:text-[var(--color-text-dark)]">
              MOKM
            </span>
          </a>

          {/* Desktop Nav */}
          <div className="hidden md:flex items-center gap-1">
            {navLinks.map((link) => (
              <a
                key={link.label}
                href={link.href}
                className="px-4 py-2 rounded-lg text-sm font-medium text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)] hover:text-[var(--color-primary)] dark:hover:text-[var(--color-primary-dark)] hover:bg-[var(--color-panel)] dark:hover:bg-[var(--color-panel-dark)] transition-colors"
              >
                {link.label}
              </a>
            ))}
            <a
              href="https://github.com/Mountain-of-kings-ministry/mokm-video-editor"
              target="_blank"
              rel="noopener noreferrer"
              className="ml-4 px-5 py-2 rounded-lg text-sm font-semibold bg-[var(--color-primary)] dark:bg-[var(--color-primary-dark)] text-[var(--color-text-inverse)] dark:text-[var(--color-text-inverse-dark)] hover:brightness-110 transition-all shadow-[0_0_20px_var(--color-glow)] dark:shadow-[0_0_20px_var(--color-glow-dark)]"
            >
              Get Started
            </a>
          </div>

          {/* Mobile hamburger */}
          <button
            onClick={() => setIsOpen(!isOpen)}
            className="md:hidden p-2 rounded-lg text-[var(--color-text)] dark:text-[var(--color-text-dark)] hover:bg-[var(--color-panel)] dark:hover:bg-[var(--color-panel-dark)]"
            aria-label="Toggle menu"
          >
            {isOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
          </button>
        </div>
      </div>

      {/* Mobile menu */}
      {isOpen && (
        <div className="md:hidden border-t border-[var(--color-border)] dark:border-[var(--color-border-dark)] bg-[var(--color-base)] dark:bg-[var(--color-base-dark)]">
          <div className="px-4 pt-2 pb-4 space-y-1">
            {navLinks.map((link) => (
              <a
                key={link.label}
                href={link.href}
                onClick={() => setIsOpen(false)}
                className="block px-4 py-3 rounded-lg text-base font-medium text-[var(--color-text-muted)] dark:text-[var(--color-text-muted-dark)] hover:text-[var(--color-primary)] dark:hover:text-[var(--color-primary-dark)] hover:bg-[var(--color-panel)] dark:hover:bg-[var(--color-panel-dark)] transition-colors"
              >
                {link.label}
              </a>
            ))}
            <a
              href="https://github.com/Mountain-of-kings-ministry/mokm-video-editor"
              target="_blank"
              rel="noopener noreferrer"
              className="block mt-2 px-4 py-3 rounded-lg text-center text-base font-semibold bg-[var(--color-primary)] dark:bg-[var(--color-primary-dark)] text-[var(--color-text-inverse)] dark:text-[var(--color-text-inverse-dark)]"
            >
              Get Started
            </a>
          </div>
        </div>
      )}
    </nav>
  );
}
