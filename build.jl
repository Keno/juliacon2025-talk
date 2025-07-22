#!/usr/bin/env julia

using Pkg

# Install Typst_jll if not already installed
try
    using Typst_jll
catch
    Pkg.add("Typst_jll")
    using Typst_jll
end

# Parse command line arguments
if length(ARGS) == 0
    println("Usage: julia build.jl [watch|build|clean]")
    exit(1)
end

command = ARGS[1]
presentation_file = joinpath(@__DIR__, "slides", "presentation.typ")
output_file = joinpath(@__DIR__, "slides", "presentation.pdf")

if command == "build"
    println("Building presentation...")
    run(`$(Typst_jll.typst()) compile $presentation_file $output_file --font-path fonts`)
    println("✓ Built: $output_file")
    
elseif command == "watch"
    println("Watching for changes...")
    println("PDF will be generated at: $output_file")
    println("Use a PDF viewer with auto-reload to see live updates")
    println("\nPress Ctrl+C to stop watching")
    
    try
        run(`$(Typst_jll.typst()) watch $presentation_file $output_file --font-path fonts`)
    catch e
        if isa(e, InterruptException)
            println("\n✓ Watch mode stopped")
        else
            rethrow(e)
        end
    end
    
elseif command == "clean"
    println("Cleaning generated files...")
    if isfile(output_file)
        rm(output_file)
        println("✓ Removed: $output_file")
    else
        println("✓ No files to clean")
    end
    
else
    println("Unknown command: $command")
    println("Available commands: build, watch, clean")
    exit(1)
end