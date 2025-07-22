# Constants are no longer constant - what's up with that?

JuliaCon 2025 Presentation by Keno Fischer

## About

This presentation explores the changes to constant redefinition and world ages in Julia 1.12.

## Technology Stack

- **Typst**: Modern typesetting system
- **Touying**: Presentation framework for Typst
- **Fletcher**: Diagram support

## Prerequisites

This presentation uses Julia's `typst_jll` package, so you only need Julia installed. No separate Typst installation required!

## Usage

### Watch Mode (Live Preview)
```bash
./watch.sh
# Or
make watch
```

Then open `slides/presentation.pdf` in a PDF viewer that supports auto-reload:
- macOS: Skim (enable auto-reload in preferences)
- Linux: Zathura or Evince
- Cross-platform: VS Code with PDF preview extension

### First Time Setup
```bash
make setup
# Or: julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

### Build PDF
```bash
make build
# Or directly:
julia --project=. build.jl build
```

### Clean
```bash
make clean
```

## Editing

Edit `slides/presentation.typ` in any text editor. The presentation includes:
- Julia syntax highlighting
- Diagrams using Fletcher
- Julia-themed colors (purple/green)
- Metropolis theme from Touying

## VS Code Integration

For the best experience, install the Typst LSP extension:
1. Install "Typst LSP" extension
2. Open the PDF preview panel
3. Edit and see live updates

## Structure

```
├── slides/
│   └── presentation.typ    # Main presentation file
├── assets/                 # Images and resources
├── diagrams/              # Additional diagrams
├── scripts/               # Helper scripts
├── Makefile              # Build commands
├── watch.sh              # Watch script
└── README.md            # This file
```