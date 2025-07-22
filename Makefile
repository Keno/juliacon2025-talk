.PHONY: all watch build pdf clean help setup

# Default target
all: build

# Setup Julia environment
setup:
	@echo "Setting up Julia environment..."
	@julia --project=. -e 'using Pkg; Pkg.instantiate()'

# Watch for changes and rebuild
watch: setup
	@julia --project=. build.jl watch

# Build slides
build: setup
	@julia --project=. build.jl build

# Build PDF (same as build for Typst)
pdf: build

# Clean generated files
clean:
	@julia --project=. build.jl clean

# Help
help:
	@echo "Available commands:"
	@echo "  make setup  - Install Julia dependencies"
	@echo "  make watch  - Watch for changes and auto-rebuild"
	@echo "  make build  - Build presentation to PDF"
	@echo "  make pdf    - Same as build"
	@echo "  make clean  - Remove generated files"
	@echo "  make help   - Show this help message"