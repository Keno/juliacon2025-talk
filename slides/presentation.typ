// Julia colors
#let julia-purple = rgb("#AA79C1")
#let julia-green = rgb("#389826")
#let julia-red = rgb("#CB3C33")

// Page setup
#set page(
  paper: "presentation-16-9",
  margin: (x: 2cm, y: 2cm),
  header: align(right)[#text(fill: gray, size: 10pt)[JuliaCon 2025]],
  numbering: "1 / 1",
)

// Typography
#set text(size: 20pt)
#show heading.where(level: 1): set text(fill: julia-purple, size: 36pt, weight: "bold")
#show heading.where(level: 2): set text(fill: julia-green, size: 28pt)
#show raw.where(block: true): it => block(
  fill: rgb("#f5f5f5"),
  inset: 12pt,
  radius: 4pt,
  width: 100%,
  text(font: "JuliaMono", size: 16pt, it)
)

// Import packages
#import "@preview/fletcher:0.5.2" as fletcher: diagram, node, edge
#import "@preview/ansi-render:0.6.1": *

// Define dark theme for terminal
#let terminal-theme = (
  black: rgb("#000000"),
  red: rgb("#cd3131"),
  green: rgb("#0dbc79"),
  yellow: rgb("#e5e510"),
  blue: rgb("#2472c8"),
  magenta: rgb("#bc3fbc"),
  cyan: rgb("#11a8cd"),
  white: rgb("#e5e5e5"),
  bright-black: rgb("#666666"),
  bright-red: rgb("#f14c4c"),
  bright-green: rgb("#23d18b"),
  bright-yellow: rgb("#f5f543"),
  bright-blue: rgb("#3b8eea"),
  bright-magenta: rgb("#d670d6"),
  bright-cyan: rgb("#29b8db"),
  bright-white: rgb("#e5e5e5"),
  gray: rgb("#808080"),
  default-bg: rgb("#0c0c0c"),
  default-fg: rgb("#cccccc"),
)

// Title slide
#align(center + horizon)[
  #text(size: 42pt, fill: julia-purple, weight: "bold")[
    Constants are no longer constant -\
    what's up with that?
  ]
  
  #v(2em)
  
  #text(size: 28pt)[JuliaCon 2025]
  
  #v(2em)
  
  #text(size: 24pt)[
    Keno Fischer\
    Core Julia Developer & CTO at JuliaHub
  ]
  
  #v(1em)
  
  #text(size: 20pt)[
    July 24, 2025 | 10:00-10:30\
    Lawrence Room 120 - REPL Main Stage
  ]
]

#pagebreak()

// Motivation: Struct redefinition with Revise
= Motivation: Interactive Development

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  
  // Left: REPL
  block(
    fill: rgb("#0c0c0c"),
    inset: 15pt,
    radius: 5pt,
    width: 100%,
    stroke: 0.5pt + rgb("#333333"),
    [
      #place(
        bottom + right,
        dx: 12pt,
        dy: 12pt,
        align(center + horizon)[
          #box(width: 15pt, height: 15pt, baseline: 3pt)[
            // Scale factor: 15pt / 350 = 0.0429
            // Red circle: center (88.4, 250) -> (3.8pt, 10.7pt)
            #place(dx: 3.8pt - 3.2pt, dy: 10.7pt - 3.2pt)[#circle(radius: 3.2pt, fill: julia-red)]
            // Green circle: center (175, 100) -> (7.5pt, 4.3pt)
            #place(dx: 7.5pt - 3.2pt, dy: 4.3pt - 3.2pt)[#circle(radius: 3.2pt, fill: julia-green)]
            // Purple circle: center (261.6, 250) -> (11.2pt, 10.7pt)
            #place(dx: 11.2pt - 3.2pt, dy: 10.7pt - 3.2pt)[#circle(radius: 3.2pt, fill: julia-purple)]
          ]
          #h(-4pt)
          #text(fill: white, size: 10pt, weight: "bold")[1.11]
        ]
      )
      #text(fill: white)[
        #ansi-render("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0musing Revise\n\n\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mincludet(\"struct.jl\")\n\n\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mp = Point(1.0, 2.0)\nPoint(1.0, 2.0)", font: "JuliaMono", size: 13pt, theme: terminal-theme)
      ]
    ]
  ),
  
  // Right: struct.jl
  block(
    fill: rgb("#f5f5f5"),
    inset: 15pt,
    radius: 5pt,
    width: 100%,
    stroke: 1pt + rgb("#e0e0e0"),
    [
      #text(size: 12pt, fill: gray)[struct.jl]
      #v(0.5em)
      ```julia
struct Point
    x::Float64
    y::Float64
end
      ```
    ]
  )
)

#pagebreak()

// Slide 2: Modification
= Modifying the Struct

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  
  // Left: REPL (same state)
  block(
    fill: rgb("#0c0c0c"),
    inset: 15pt,
    radius: 5pt,
    width: 100%,
    stroke: 0.5pt + rgb("#333333"),
    [
      #place(
        bottom + right,
        dx: -3pt,
        dy: -3pt,
        align(center + horizon)[
          #box(width: 15pt, height: 15pt)[
            // Scale factor: 15pt / 350 = 0.0429
            // Red circle: center (88.4, 250) -> (3.8pt, 10.7pt)
            #place(dx: 3.8pt - 3.2pt, dy: 10.7pt - 3.2pt)[#circle(radius: 3.2pt, fill: julia-red)]
            // Green circle: center (175, 100) -> (7.5pt, 4.3pt)
            #place(dx: 7.5pt - 3.2pt, dy: 4.3pt - 3.2pt)[#circle(radius: 3.2pt, fill: julia-green)]
            // Purple circle: center (261.6, 250) -> (11.2pt, 10.7pt)
            #place(dx: 11.2pt - 3.2pt, dy: 10.7pt - 3.2pt)[#circle(radius: 3.2pt, fill: julia-purple)]
          ]
          #h(1pt)
          #text(fill: white, size: 10pt, weight: "bold")[1.11]
        ]
      )
      #text(fill: white)[
        #ansi-render("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0musing Revise\n\n\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mincludet(\"struct.jl\")\n\n\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mp = Point(1.0, 2.0)\nPoint(1.0, 2.0)\n\n\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[90m# Edit struct.jl...\u{1b}[39m", font: "JuliaMono", size: 13pt, theme: terminal-theme)
      ]
    ]
  ),
  
  // Right: struct.jl with changes highlighted
  block(
    fill: rgb("#f5f5f5"),
    inset: 15pt,
    radius: 5pt,
    width: 100%,
    stroke: 1pt + rgb("#e0e0e0"),
    [
      #text(size: 12pt, fill: gray)[struct.jl]
      #v(0.5em)
      #block(
        fill: rgb("#fff5f5"),
        inset: 8pt,
        radius: 4pt,
        width: 100%,
        [
          ```julia
struct Point
    x::Float64
    y::Float64
    z::Float64  # New field!
end
          ```
        ]
      )
    ]
  )
)

#pagebreak()

// Slide 3: Error message
= The Problem

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  
  // Left: REPL with error
  block(
    fill: rgb("#0c0c0c"),
    inset: 15pt,
    radius: 5pt,
    width: 100%,
    stroke: 0.5pt + rgb("#333333"),
    [
      #place(
        bottom + right,
        dx: -3pt,
        dy: -3pt,
        align(center + horizon)[
          #box(width: 15pt, height: 15pt, baseline: -7pt)[
            // Scale factor: 15pt / 350 = 0.0429
            // Red circle: center (88.4, 250) -> (3.8pt, 10.7pt)
            #place(dx: 3.8pt - 3.2pt, dy: 10.7pt - 3.2pt)[#circle(radius: 3.2pt, fill: julia-red)]
            // Green circle: center (175, 100) -> (7.5pt, 4.3pt)
            #place(dx: 7.5pt - 3.2pt, dy: 4.3pt - 3.2pt)[#circle(radius: 3.2pt, fill: julia-green)]
            // Purple circle: center (261.6, 250) -> (11.2pt, 10.7pt)
            #place(dx: 11.2pt - 3.2pt, dy: 10.7pt - 3.2pt)[#circle(radius: 3.2pt, fill: julia-purple)]
          ]
          #h(1pt)
          #text(fill: white, size: 10pt, weight: "bold")[1.11]
        ]
      )
      #text(fill: white)[
        #ansi-render("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mp = Point(1.0, 2.0, 3.0)
\u{1b}[91mERROR: \u{1b}[39mLoadError: invalid redefinition of constant Main.Point
Stacktrace:
 [1] top-level scope
   @ struct.jl:7
in expression starting at struct.jl:7

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[90m# 😞 Need to restart Julia!\u{1b}[39m", font: "JuliaMono", size: 13pt, theme: terminal-theme)
      ]
    ]
  ),
  
  // Right: struct.jl
  block(
    fill: rgb("#f5f5f5"),
    inset: 15pt,
    radius: 5pt,
    width: 100%,
    stroke: 1pt + rgb("#e0e0e0"),
    [
      #text(size: 12pt, fill: gray)[struct.jl]
      #v(0.5em)
      ```julia
struct Point
    x::Float64
    y::Float64
    z::Float64  # New field!
end
      ```
      
      #v(1em)
      #text(size: 16pt, fill: julia-red, style: "italic")[
        Revise.jl cannot handle struct\
        redefinitions in Julia 1.11
      ]
    ]
  )
)