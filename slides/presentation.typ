// JuliaCon 2025 Presentation - Constants are no longer constant
//
// To build this presentation:
// - Run `julia build.jl build` to generate PDF
// - Run `julia build.jl watch` for live preview on port 8000

// Julia colors
#let julia-purple = rgb("#AA79C1")
#let julia-green = rgb("#389826")
#let julia-red = rgb("#CB3C33")
#let julia-blue = rgb("#4063D8")

// Page setup
#set page(
  paper: "presentation-16-9",
  margin: (x: 2cm, y: 2cm),
  header: align(right)[#text(fill: gray, size: 10pt)[JuliaCon 2025]],
  numbering: (..nums) => text(fill: gray, size: 10pt)[
    #nums.pos().first() / #nums.pos().last()
  ],
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
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/ansi-render:0.6.1": *
#import "@preview/pinit:0.2.2": *
#import "@preview/cades:0.3.0": qr-code

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

// Reusable Julia terminal component
// Usage: julia-terminal("terminal content")
// Optional: julia-terminal("content", version: "1.12")
#let julia-terminal(content, version: "1.11") = block(
  fill: rgb("#0c0c0c"),
  inset: 15pt,
  radius: 5pt,
  width: 100%,
  stroke: 0.5pt + rgb("#333333"),
  [
    #text(fill: white)[
      #ansi-render(content, font: "JuliaMono", size: 13pt, theme: terminal-theme)
    ]
    // Place logo after content to ensure it's on top
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
        #text(fill: white, size: 10pt, weight: "bold")[#version]
      ]
    )
  ]
)

// Title slide
= Constants are no longer constant - wat?

#grid(
  columns: (4fr, 1fr),
  column-gutter: 2em,
  
  align(center + horizon)[
    #text(size: 42pt, fill: julia-purple, weight: "bold")[
    ]
    
    #v(1.5em)
    
    #text(size: 28pt)[JuliaCon 2025]
    
    #v(1.5em)
    
    #text(size: 24pt)[
      Keno Fischer
    ]
    #v(0.1em)
    #text(size: 8pt)[
      Also Claude, but it wasn't very good at slides
    ]
  ],
  
  align(center + horizon)[
    #box(
      width: 80pt,
      height: 80pt,
      qr-code("https://github.com/Keno/juliacon2025-talk", width: 80pt)
    )
    #v(0.2em)
    #text(size: 9pt)[github.com/Keno/\juliacon2025-talk]
  ]
)

#pagebreak()

// Motivation: Struct redefinition with Revise
= Motivation: Interactive Development

#grid(
  columns: (2fr, 1fr),
  column-gutter: 1em,
  align: horizon,
  
  // Left: REPL
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0musing Revise\n\n\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mincludet(\"struct.jl\")\n\n\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mporig = Point(1.0, 2.0)\nPoint(1.0, 2.0)"),
  
  // Right: struct.jl
  block(
    fill: rgb("#f5f5f5"),
    inset: 15pt,
    radius: 5pt,
    width: 100%,
    stroke: 1pt + rgb("#e0e0e0"),
    [
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

// Modification
= Modifying the Struct

#grid(
  columns: (2fr, 1fr),
  column-gutter: 1em,
  align: horizon,
  
  // Left: REPL (same state)
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0musing Revise\n\n\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mincludet(\"struct.jl\")\n\n\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mporig = Point(1.0, 2.0)\nPoint(1.0, 2.0)\n\n\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[90m# Edit struct.jl...\u{1b}[39m"),
  
  // Right: struct.jl with changes highlighted
  block(
    fill: rgb("#f5f5f5"),
    inset: 15pt,
    radius: 5pt,
    width: 100%,
    stroke: 1pt + rgb("#e0e0e0"),
    [
      ```julia
struct Point
    x::Float64
    y::Float64
    # New field!
    z::Float64
end
      ```
    ]
  )
)

#pagebreak()

// Error message
= The Problem

#grid(
  columns: (2fr, 1fr),
  column-gutter: 1em,
  align: horizon,
  
  // Left: REPL with error
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mp = Point(1.0, 2.0, 3.0)
\u{1b}[91mERROR: \u{1b}[39mLoadError: invalid redefinition of constant Main.Point
Stacktrace:
 [1] top-level scope
   @ struct.jl:7
in expression starting at struct.jl:7

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[90m# 😞 Need to restart Julia!\u{1b}[39m"),
  
  // Right: struct.jl
  block(
    fill: rgb("#f5f5f5"),
    inset: 15pt,
    radius: 5pt,
    width: 100%,
    stroke: 1pt + rgb("#e0e0e0"),
    [
      ```julia
struct Point
    x::Float64
    y::Float64
    # New field!
    z::Float64
end
      ```
    ]
  )
)

#place(bottom + center, dy: -50pt)[
  #text(size: 18pt, fill: julia-red, style: "italic", weight: "bold")[
    Revise.jl cannot handle struct redefinitions in Julia 1.11
  ]
]

#pagebreak()

// Solution in Julia 1.12
// To reproduce the output shown below, see examples/reproduce_julia_12_output.jl
// This script demonstrates the struct redefinition fix in Julia 1.12
= Fixed in Julia 1.12!

#grid(
  columns: (2fr, 1fr),
  column-gutter: 1em,
  align: horizon,
  
  // Left: REPL with Julia 1.12
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[90m# After editing struct.jl...\u{1b}[39m

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mp = Point(1.0, 2.0, 3.0)
Point(1.0, 2.0, 3.0)

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mporig
@world(Point, 38520:38525)(1.0, 2.0)

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[90m# 🎉 It works!\u{1b}[39m", version: "1.12"),
  
  // Right: struct.jl
  block(
    fill: rgb("#f5f5f5"),
    inset: 15pt,
    radius: 5pt,
    width: 100%,
    stroke: 1pt + rgb("#e0e0e0"),
    [
      ```julia
struct Point
    x::Float64
    y::Float64
    # New field!
    z::Float64
end
      ```
    ]
  )
)

#place(bottom + center, dy: -50pt)[
  #text(size: 18pt, fill: julia-green, style: "italic", weight: "bold")[
    Struct redefinition now works with Revise.jl in Julia 1.12!
  ]
]

#pagebreak()

// Fake ending
#align(center + horizon)[
  #text(size: 56pt, fill: julia-purple, weight: "bold")[
    Thank You!
  ]
  
  #v(2em)
  
  #text(size: 28pt, fill: gray)[
    Questions?
  ]
  
  #v(3em)
  
  #text(size: 20pt)[
    Keno Fischer
    
    #link("mailto:keno@juliahub.com")[keno\@juliahub.com] • #box(baseline: 2pt)[#image("github-mark.svg", width: 16pt)] \@Keno
  ]
]

#pagebreak()

// Julia 1.11 Data Structures (Internal)
= Julia 1.11: Binding Internals

#align(center)[
  #block(width: 95%)[
    #grid(
      columns: (1fr, 2fr, 2fr),
      column-gutter: 1em,
      align: horizon,
      
      // Module
      block(
        fill: julia-purple.lighten(90%),
        stroke: 1pt + julia-purple,
        radius: 5pt,
        inset: 4pt,
        width: 100%,
      )[
        #text(weight: "bold", size: 15pt)[Module]
        #table(
          columns: (1fr,),
          stroke: (x, y) => (
            left: 0pt,
            right: 0pt,
            top: if y == 0 { 1pt } else { 0.5pt },
            bottom: 1pt,
          ),
          fill: (x, y) => if y == 0 { gray.lighten(90%) } else { white },
          text(size: 12pt, weight: "bold")[Usings],
          text(size: 12pt)[::Module],
          text(size: 9pt)[...],
        )
        #table(
          columns: (1fr, 1fr),
          stroke: (x, y) => (
            left: 0pt,
            right: 0pt,
            top: if y == 0 { 1pt } else { 0.5pt },
            bottom: 1pt,
          ),
          fill: (x, y) => if y == 0 { gray.lighten(90%) } else { white },
          text(size: 12pt, weight: "bold")[Name], text(size: 12pt, weight: "bold")[→],
          text(size: 12pt)[::Symbol], text(size: 12pt)[::Binding],
          text(size: 12pt)[...], text(size: 12pt)[...],
        )
      ],
      
      // Binding
      block(
        fill: julia-green.lighten(90%),
        stroke: 1pt + julia-green,
        radius: 5pt,
        inset: 2pt,
        width: 100%,
      )[
        #text(size: 13pt)[
          #raw(lang: "julia", block: true, "struct Binding
    value::Any
    globalref::GlobalRef
    owner::Binding
    ty::Type
    flags::UInt32
    # constp:1
    # exportp:1
    # publicp:1
    # imported: 1
end")
        ]
      ],
      
      // GlobalRef
      block()[
        #block(
          fill: julia-red.lighten(90%),
          stroke: 1pt + julia-red,
          radius: 5pt,
          inset: 2pt,
          width: 100%,
        )[
          #text(size: 13pt)[
            #show raw: it => {
              show regex("pin\d"): it => pin(eval(it.text.slice(3)))
              it
            }
            #raw(lang: "julia", block: true, "struct GlobalRef
    mod::Module
    name::Symbol
    binding::Binding
  end")
          ]
        ]
        #text(size: 12pt)[Almost like Binding, but can exist without entry in the binding table. May be merged into Binding in the future]
      ]
    )
  ]
]

#pagebreak()

// Example - Undefined (No Binding)
= Example: Undefined Variable

#grid(
  columns: (1fr, 1fr),
  column-gutter: 2em,
  
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0munknown_var
\u{1b}[91mERROR: \u{1b}[39mUndefVarError: `unknown_var` 
not defined in `Main`

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0misdefined(Main, :unknown_var)
false
"),
  
  align(center)[
      #block(
        fill: julia-purple.lighten(90%),
        stroke: 1pt + julia-purple,
        radius: 5pt,
        inset: 4pt,
        width: 100%,
      )[
        #text(weight: "bold", size: 15pt)[Main]
        #table(
          columns: (1fr,),
          stroke: (x, y) => (
            left: 0pt,
            right: 0pt,
            top: if y == 0 { 1pt } else { 0.5pt },
            bottom: 1pt,
          ),
          fill: (x, y) => if y == 0 { gray.lighten(90%) } else { white },
          text(size: 12pt, weight: "bold")[Usings],
        )
        #table(
          columns: (1fr, 1fr),
          stroke: (x, y) => (
            left: 0pt,
            right: 0pt,
            top: if y == 0 { 1pt } else { 0.5pt },
            bottom: 1pt,
          ),
          fill: (x, y) => if y == 0 { gray.lighten(90%) } else { white },
          text(size: 12pt, weight: "bold")[Name], text(size: 12pt, weight: "bold")[→],
        )
      ],
  ]
)

#v(1em)
#text(size: 24pt)[
  No bindings in the table, no `usings` => UndefVarError.
]

#pagebreak()

// Drawing definitions
#let module-node(pos: (0, 0), body: text[Main], name: <module>, ..args) = (node(pos, width: 100pt, height: 70pt, block(
        fill: julia-purple.lighten(90%),
        stroke: 1pt + julia-purple,
        radius: 5pt,
        inset: 4pt,
        width: 100%, height: 100%,
      )[], name: name),
 node(((name: name, anchor: "north"), 20%, (name: name, anchor: "south")), body))

#let binding-node(pos: (1, 0), name: <binding>, value: text[1], value-type: text[Any], flags: text[-]) = (node(pos, corner-radius:5pt, width:120pt, height:80pt, block[#value\ #value-type\ #text(fill: red)[#flags]], name: name, fill: julia-green.lighten(90%),
        stroke: 1pt + julia-green,
),
 node((rel: (-10pt, -5pt), to: (name: name, anchor: "north-east")), text(size: 40pt)[•], name: label(str(name) + "-dot")))

#let binding112-node(pos: (1, 0), name: <binding>, value: text[1], flags: text[-]) = (node(pos, corner-radius:5pt, width:120pt, height:30pt, block[#value], name: name, fill: julia-green.lighten(90%),
        stroke: 1pt + julia-green,
),
 node((rel: (-10pt, 10pt), to: (name: name, anchor: "south-east")), text(size: 40pt)[•], name: label(str(name) + "-dot")))

#let partition-node(..args, pos: (0, 1), name: <part>, value: text[1], kind: text[CONST], height: 80pt) = (node(..args, pos, corner-radius:5pt, width:120pt, height: height, block[#text(weight: "bold")[#kind]\ #value], name: name, fill: julia-blue.lighten(90%),
        stroke: 1pt + julia-blue,
),
 node((rel: (-10pt, 10pt), to: (name: name, anchor: "south-east")), text(size: 40pt)[•], name: label(str(name) + "-dot")))
#let partition-import-node(..args, pos: (1, 0), name: <part>, kind: text[EXPLICIT], height: 80pt) = (node(..args, pos, corner-radius:5pt, width:120pt, height: height, block[#text(weight: "bold")[#kind]#v(1em)], name: name, fill: julia-blue.lighten(90%),
        stroke: 1pt + julia-blue,
),
 node((rel: (-10pt, 10pt), to: (name: name, anchor: "south-east")), text(size: 40pt)[•], name: label(str(name) + "-dot")),
 node(((name: name, anchor: "north"), 50%, (name: name, anchor: "south")), text(size: 40pt)[•], name: label(str(name) + "-restriction-dot")))


#let module-binding-def(module: <module>, symbol: text[:x], name: <xdot>) = {
  let pos-name = label(str(module) + "-guide")
  return (
  node(((name: module, anchor: "north"), 70%, (name: module, anchor: "south")), name: pos-name, text[.], layer: -1),
  node((rel: (-20pt, 0pt), to: (name: pos-name, anchor: "center")), text[:x]),
  node((rel: (20pt, 0pt), to: (name: pos-name, anchor: "center")), text(size: 40pt)[•], name: name))
}

#let module-using-def(module: <module>, ypos: 70%, name: <xdot>) = node(((name: module, anchor: "north"), ypos, (name: module, anchor: "south")), name: name, text(size: 40pt)[•])

= Example: Simple Constant

#grid(
  columns: (1fr, 3fr),
  column-gutter: 2em,
  align: horizon,
  
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mconst x = 1
1

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mx
1
"),
  
diagram(
 node-shape: rect,
 module-node(pos: (0,0)),
 binding-node(pos: (1,0), value: text[1], value-type: text[Any], flags: text[const]),
 module-binding-def(),
 edge(<xdot.center>, (rel: (0, 0.7), to: <xdot.center>), (vertical: (), horizontal: <binding.south>), <binding.south>, "-|>", layer: 1),
 edge(<binding-dot.center>, (rel: (0, -0.3), to: <binding-dot.center>), (vertical: (), horizontal: <binding.north>), <binding.north>, "-|>", layer: 1)
),
)

#v(1em)
#text(size: 24pt)[
  Single Binding with value 1, const flag set, owner points to self.
]

#pagebreak()


= Julia 1.11: Simple Global

#grid(
  columns: (1fr, 3fr),
  column-gutter: 2em,
  align: horizon,
  
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mx = 1
1

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mx
1
"),
  
diagram(
 node-shape: rect,
 module-node(pos: (0,0)),
 module-binding-def(),
 binding-node(pos: (1,0), value: text[1], value-type: text[Any], flags: text[-]),
 edge(<xdot.center>, (rel: (0, 0.7), to: <xdot.center>), (vertical: (), horizontal: <binding.south>), <binding.south>, "-|>", layer: 1),
 edge(<binding-dot.center>, (rel: (0, -0.3), to: <binding-dot.center>), (vertical: (), horizontal: <binding.north>), <binding.north>, "-|>", layer: 1)
),
)
#v(1em)
#text(size: 24pt)[
  Basically the same, but no const flag.
]

#pagebreak()

= Example: Typed Global

#grid(
  columns: (1fr, 3fr),
  column-gutter: 2em,
  align: horizon,
  
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mx::Int = 1
1

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mx
1
"),
  
diagram(
 node-shape: rect,
 module-node(pos: (0,0)),
 module-binding-def(),
 binding-node(pos: (1,0), value: text[1], value-type: text[Int], flags: text[-]),
 edge(<xdot.center>, (rel: (0, 0.7), to: <xdot.center>), (vertical: (), horizontal: <binding.south>), <binding.south>, "-|>", layer: 1),
 edge(<binding-dot.center>, (rel: (0, -0.3), to: <binding-dot.center>), (vertical: (), horizontal: <binding.north>), <binding.north>, "-|>", layer: 1)
),
)
#v(1em)
#text(size: 24pt)[
  Sets binding type
]



#pagebreak()


= Julia 1.11: Simple Import

#grid(
  columns: (1.5fr, 2.5fr),
  column-gutter: 2em,
  align: horizon,
  
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mmodule A; const x = 1; end

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mimport .A: x
  
\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mx
1
"),
  
diagram(
 node-shape: rect,
 module-node(pos: (0,0), name: <Main>),
 binding-node(pos: (0,1), value: text[\#undef], value-type: text[\#undef], flags: text[imported], name: <Main-binding>),
 module-binding-def(module: <Main>, name: <Maindot>),
 module-node(pos: (1,0), body: text[A], name: <A>),
 binding-node(pos: (1,1), value: text[1], value-type: text[Any], flags: text[const], name: <A-binding>),
 module-binding-def(module: <A>, name: <Adot>),
 edge(<Maindot.center>, (rel: (0, 0.35), to: <Maindot.center>), (vertical: (), horizontal: <Main-binding.south>), <Main-binding.north>, "-|>", layer: 1),
 edge(<Adot.center>, (rel: (0, 0.35), to: <Adot.center>), (vertical: (), horizontal: <A-binding.south>), <A-binding.north>, "-|>", layer: 1),
 edge(<Main-binding-dot.center>, (rel: (0.2, 0), to: <Main-binding-dot.center>), (horizontal: (), vertical: <A-binding.west>), <A-binding.west>, "-|>", layer: 1)
),
)
#v(1em)
#text(size: 24pt)[
  Owner field points to import.
]


= Example: More Complicated Import

#grid(
  columns: (1.5fr, 2.5fr),
  column-gutter: 2em,
  align: horizon,
  
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mmodule A; const x = 1; end

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mmodule B; import ..A: x; end
  
\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mimport .B: x
  
\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mx
1
"),
  
diagram(
 node-shape: rect,
 module-node(pos: (0,0), name: <Main>),
 binding-node(pos: (0,1), value: text[\#undef], value-type: text[\#undef], flags: text[imported], name: <Main-binding>),
 module-binding-def(module: <Main>, name: <Maindot>),
 module-node(pos: (1,0), body: text[B], name: <B>),
 binding-node(pos: (1,1), value: text[\#undef], value-type: text[\#undef], flags: text[imported], name: <B-binding>),
 module-binding-def(module: <B>, name: <Bdot>),
 module-node(pos: (2,0), body: text[A], name: <A>),
 binding-node(pos: (2,1), value: text[1], value-type: text[Any], flags: text[const], name: <A-binding>),
 module-binding-def(module: <A>, name: <Adot>),
 edge(<Maindot.center>, (rel: (0, 0.35), to: <Maindot.center>), (vertical: (), horizontal: <Main-binding.south>), <Main-binding.north>, "-|>", layer: 1),
 edge(<Adot.center>, (rel: (0, 0.35), to: <Adot.center>), (vertical: (), horizontal: <A-binding.south>), <A-binding.north>, "-|>", layer: 1),
 edge(<Bdot.center>, (rel: (0, 0.35), to: <Bdot.center>), (vertical: (), horizontal: <B-binding.south>), <B-binding.north>, "-|>", layer: 1),
 edge(<Main-binding-dot.center>, (rel: (0.2, 0), to: <Main-binding-dot.center>), (rel: (0, 1.2), to: ()), (vertical: (rel: (0, 1.2), to: <Main-binding-dot.center>), horizontal: (rel: (0.2, 0), to: <B-binding-dot.center>)), (horizontal: (), vertical: <A-binding.west>), <A-binding.west>, "-|>", layer: 1),
 edge(<B-binding-dot.center>, (rel: (0.2, 0), to: <B-binding-dot.center>), (horizontal: (), vertical: <A-binding.west>), <A-binding.west>, "-|>", layer: 1)
),
)
#v(1em)
#text(size: 24pt)[
  Owner field points to import.
]

#pagebreak()

= Declared, but unassigned global

#grid(
  columns: (1fr, 1fr),
  column-gutter: 2em,
  align: horizon,
  
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mglobal x

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mx
\u{1b}[91mERROR: \u{1b}[39mUndefVarError: `x` not defined in `Main`
"),
  
diagram(
 node-shape: rect,
 module-node(pos: (0,0)),
 module-binding-def(),
 binding-node(pos: (1,0), value: text[\#undef], value-type: text[\#undef], flags: text[-]),
 edge(<xdot.center>, (rel: (0, 0.7), to: <xdot.center>), (vertical: (), horizontal: <binding.south>), <binding.south>, "-|>", layer: 1),
 edge(<binding-dot.center>, (rel: (0, -0.3), to: <binding-dot.center>), (vertical: (), horizontal: <binding.north>), <binding.north>, "-|>", layer: 1)
),
)

= Declared, but unassigned typed global

#grid(
  columns: (1fr, 1fr),
  column-gutter: 2em,
  align: horizon,
  
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mglobal::Int x

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mx
\u{1b}[91mERROR: \u{1b}[39mUndefVarError: `x` not defined in `Main`
"),
  
diagram(
 node-shape: rect,
 module-node(pos: (0,0)),
 module-binding-def(),
 binding-node(pos: (1,0), value: text[\#undef], value-type: text[Int], flags: text[-]),
 edge(<xdot.center>, (rel: (0, 0.7), to: <xdot.center>), (vertical: (), horizontal: <binding.south>), <binding.south>, "-|>", layer: 1),
 edge(<binding-dot.center>, (rel: (0, -0.3), to: <binding-dot.center>), (vertical: (), horizontal: <binding.north>), <binding.north>, "-|>", layer: 1)
),
)

#pagebreak()

#v(1fr)
#align(center + horizon)[
  #text(size: 48pt, fill: julia-purple, weight: "bold")[
    Binding Resolution
  ]
]
#v(1fr)

#pagebreak()

= Binding Resolution


#grid(
  columns: (1.5fr, 2.5fr),
  column-gutter: 2em,
  align: horizon,
  
  julia-terminal(
"\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mmodule A; const x = 1;
                 export x; end

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0musing .A
"),
  
diagram(
 node-shape: rect,
 module-node(pos: (0,0), name: <Main>),
 module-using-def(module: <Main>, ypos: 45%, name: <Mainusing>),
 module-node(pos: (1,0), body: text[A], name: <A>),
 binding-node(pos: (1,1), value: text[1], value-type: text[Any], flags: text[const export], name: <A-binding>),
 module-binding-def(module: <A>, name: <Adot>),
 edge(<Mainusing.center>, (horizontal: <Mainusing.center>, vertical: <A.west>), <A.west>, "-|>", layer: 1),
 edge(<Adot.center>, (rel: (0, 0.35), to: <Adot.center>), (vertical: (), horizontal: <A-binding.south>), <A-binding.north>, "-|>", layer: 1),
),
)

#pagebreak()

= Binding Resolution (Resolved)


#grid(
  columns: (1.5fr, 2.5fr),
  column-gutter: 2em,
  align: horizon,
  
  julia-terminal(
"\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mmodule A; const x = 1;
                 export x; end

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0musing .A

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mx
"),
  
diagram(
 node-shape: rect,
 module-node(pos: (0,0), name: <Main>),
 binding-node(pos: (0,1), value: text[\#undef], value-type: text[\#undef], flags: text[-], name: <Main-binding>),
 module-binding-def(module: <Main>, name: <Maindot>),
 module-node(pos: (1,0), body: text[A], name: <A>),
 binding-node(pos: (1,1), value: text[1], value-type: text[Any], flags: text[const export], name: <A-binding>),
 module-binding-def(module: <A>, name: <Adot>),
 module-using-def(module: <Main>, ypos: 45%, name: <Mainusing>),
 edge(<Mainusing.center>, (horizontal: <Mainusing.center>, vertical: <A.west>), <A.west>, "-|>", layer: 1),
 edge(<Maindot.center>, (rel: (0, 0.35), to: <Maindot.center>), (vertical: (), horizontal: <Main-binding.south>), <Main-binding.north>, "-|>", layer: 1),
 edge(<Adot.center>, (rel: (0, 0.35), to: <Adot.center>), (vertical: (), horizontal: <A-binding.south>), <A-binding.north>, "-|>", layer: 1),
 edge(<Main-binding-dot.center>, (rel: (0.2, 0), to: <Main-binding-dot.center>), (horizontal: (), vertical: <A-binding.west>), <A-binding.west>, "-|>", layer: 1)
),
)

Problem: When does binding resolution happen?

= The Compiler Resolves Bindings (Sometimes)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 2em,
  align: horizon,
  
julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mmodule A; const x = 1; export x; end
Main.A

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0musing .A

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mf() = x
f (generic function with 1 method)

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mfor _ in [] x end

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mconst x = 2
\u{1b}[91mERROR: \u{1b}[39mcannot assign a value to imported variable A.x from module Main
Stacktrace:
 [1] top-level scope
   @ REPL[5]:1
"),
  
julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mmodule A; const x = 1; export x; end
Main.A

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0musing .A

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mf() = x
f (generic function with 1 method)

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mwhile false x end

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mconst x = 2
2
"),
)
  

#pagebreak()

= Julia 1.12: Binding Internals

#align(center)[
  #block(width: 95%)[
    #grid(
      columns: (1.2fr, 2fr, 2.5fr),
      column-gutter: 1em,
      align: horizon,
      
      // Module
      block(
        fill: julia-purple.lighten(90%),
        stroke: 1pt + julia-purple,
        radius: 5pt,
        inset: 4pt,
        width: 100%,
      )[
        #text(weight: "bold", size: 15pt)[Module]
        #table(
          columns: (1fr,1fr,1fr),
          stroke: (x, y) => (
            left: 0pt,
            right: 0pt,
            top: if y == 0 { 1pt } else { 0.5pt },
            bottom: 1pt,
          ),
          fill: (x, y) => if y == 0 { gray.lighten(90%) } else { white },
          text(size: 12pt, weight: "bold")[Usings],
          text(size: 12pt, weight: "bold")[Min],
          text(size: 12pt, weight: "bold")[Max],
          text(size: 12pt)[::Module],text(size: 12pt)[::Csize_t],text(size: 12pt)[::Csize_t],
          text(size: 9pt)[...],text(size: 9pt)[...],text(size: 9pt)[...]
        )
        #table(
          columns: (1fr, 1fr),
          stroke: (x, y) => (
            left: 0pt,
            right: 0pt,
            top: if y == 0 { 1pt } else { 0.5pt },
            bottom: 1pt,
          ),
          fill: (x, y) => if y == 0 { gray.lighten(90%) } else { white },
          text(size: 12pt, weight: "bold")[Name], text(size: 12pt, weight: "bold")[→],
          text(size: 12pt)[::Symbol], text(size: 12pt)[::Binding],
          text(size: 12pt)[...], text(size: 12pt)[...],
        )
      ],
      
      // Binding
      block(
        fill: julia-green.lighten(90%),
        stroke: 1pt + julia-green,
        radius: 5pt,
        inset: 2pt,
        width: 100%,
      )[
        #text(size: 13pt)[
          #raw(lang: "julia", block: true, "struct Binding
  value::Any
  globalref::
    GlobalRef
  partitions::
    BindingPartition
  backedges::
    Vetor{Binding}
  flags::UInt8
end")
        ]
      ],
      
      // BindingPartitio
      block()[
        #block(
          fill: julia-blue.lighten(90%),
          stroke: 1pt + julia-blue,
          radius: 5pt,
          inset: 2pt,
          width: 100%,
        )[
          #text(size: 13pt)[
            #show raw: it => {
              show regex("pin\d"): it => pin(eval(it.text.slice(3)))
              it
            }
            #raw(lang: "julia", block: true, 
"struct BindingPartition
  kind::Csize_t
  restriction::Any        
  min_world::Csize_t
  max_world::Csize_t
  next::BindingPartition
end")
          ]
        ]
      ]
    )
  ]
]

= Julia 1.12: Simple Constant

#grid(
  columns: (1fr, 3fr),
  column-gutter: 2em,
  align: horizon,
  
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mconst x = 1
1

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mx
1
", version: 1.12),
  
diagram(
 node-shape: rect,
 module-node(pos: (0,0)),
 binding112-node(pos: (1,0), value: text[\#undef]),
 partition-node(pos: (2,0), value: text[1]),
 module-binding-def(),
 edge(<xdot.center>, (rel: (0, 0.7), to: <xdot.center>), (vertical: (), horizontal: <binding.south>), <binding.south>, "-|>", layer: 1),
 edge(<binding-dot.center>, (rel: (0.25, 0), to: <binding-dot.center>), (horizontal: (), vertical: <part.west>), <part.west>, "-|>", layer: 1)
),
)

= Julia 1.12: Simple Global

#grid(
  columns: (1fr, 3fr),
  column-gutter: 2em,
  align: horizon,
  
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mglobal x = 1
1

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mx
1
", version: 1.12),
  
diagram(
 node-shape: rect,
 module-node(pos: (0,0)),
 binding112-node(pos: (1,0), value: text[1]),
 partition-node(pos: (2,0), value: text[Any], kind: text[GLOBAL]),
 module-binding-def(),
 edge(<xdot.center>, (rel: (0, 0.7), to: <xdot.center>), (vertical: (), horizontal: <binding.south>), <binding.south>, "-|>", layer: 1),
 edge(<binding-dot.center>, (rel: (0.25, 0), to: <binding-dot.center>), (horizontal: (), vertical: <part.west>), <part.west>, "-|>", layer: 1)
),
)

#pagebreak()

= Julia 1.12: Redefined Constant

#grid(
  columns: (1fr, 3fr),
  column-gutter: 2em,
  align: horizon,
  
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mconst x = 1
1

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mconst x = 2
2

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mx
2
", version: 1.12),
  
diagram(
 node-shape: rect,
 module-node(pos: (0,0)),
 binding112-node(pos: (1,0), value: text[\#undef]),
 partition-node(pos: (2,1), value: text[1], kind: text[CONST], name: <part1>),
 partition-node(pos: (2,0), value: text[2], kind: text[CONST], name: <part2>),
 module-binding-def(),
 edge(<xdot.center>, (rel: (0, 0.7), to: <xdot.center>), (vertical: (), horizontal: <binding.south>), <binding.south>, "-|>", layer: 1),
 edge(<binding-dot.center>, (rel: (0.25, 0), to: <binding-dot.center>), (horizontal: (), vertical: <part2.west>), <part2.west>, "-|>", layer: 1),
 // Connect second partition to first (newer points to older)
 edge(<part2-dot.center>, (rel: (0, 0.2), to: <part2-dot.center>), (vertical: (), horizontal: <part1.north>), <part1.north>, "-|>", layer: 1),
 // Red dashed line perpendicular between partitions
 edge((1.5, 0.5), (2.5, 0.5), "--", stroke: (paint: julia-red, thickness: 2pt, dash: "dashed"), label-side: right, label-pos: 0.275, label: text(fill: julia-red)[redefine x] ),
),
)

#pagebreak()

= Julia 1.12: Simple Import

#grid(
  columns: (1.5fr, 2.5fr),
  column-gutter: 2em,
  align: horizon,
  
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mmodule A; const x = 1; end

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mimport .A: x
  
\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mx
1
"),
  
diagram(
 node-shape: rect,
 spacing: (1em, 1em),
 module-node(pos: (0,0), name: <Main>),
 binding112-node(pos: (0,1), value: text[\#undef], name: <Main-binding>),
 partition-import-node(pos: (0, 2), kind: text[EXPLICIT]),
 module-binding-def(module: <Main>, name: <Maindot>),
 module-node(pos: (1,0), body: text[A], name: <A>),
 binding112-node(pos: (1, 1), value: text[\#undef], name: <A-binding>),
 partition-node(pos: (1, 2), value: text[1], kind: text[CONST], name: <Apart>),
 module-binding-def(module: <A>, name: <Adot>),
 edge(<Maindot.center>, (rel: (0, 0.25), to: <Maindot.center>), (vertical: (), horizontal: <Main-binding.south>), <Main-binding.north>, "-|>", layer: 1),
 edge(<Adot.center>, (rel: (0, 0.25), to: <Adot.center>), (vertical: (), horizontal: <A-binding.south>), <A-binding.north>, "-|>", layer: 1),
 edge(<Main-binding-dot.center>, (rel: (0, 0.18), to: <Main-binding-dot.center>), (vertical: (), horizontal: <part.north>), <part.north>, "-|>", layer: 1),
 edge(<A-binding-dot.center>, (rel: (0, 0.18), to: <A-binding-dot.center>), (vertical: (), horizontal: <Apart.north>), <Apart.north>, "-|>", layer: 1),
 edge(<part-restriction-dot.center>, (rel: (0.5, 0), to: <part-restriction-dot.center>), (horizontal: (), vertical: <A-binding.west>), <A-binding.west>, "-|>", layer: 1)
),
)

#pagebreak()

= Julia 1.12: More Complicated Import

#grid(
  columns: (1.5fr, 2.5fr),
  column-gutter: 2em,
  align: horizon,
  
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mmodule A; const x = 1; end

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mmodule B; import ..A: x; end
  
\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mimport .B: x
  
\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mx
1
", version: 1.12),
  
diagram(
 node-shape: rect,
 spacing: (1em, 1em),
 module-node(pos: (0,0), name: <Main>),
 binding112-node(pos: (0,1), value: text[\#undef], name: <Main-binding>),
 partition-import-node(pos: (0, 2), kind: text[EXPLICIT], name: <Main-part>),
 module-binding-def(module: <Main>, name: <Maindot>),
 
 module-node(pos: (1,0), body: text[B], name: <B>),
 binding112-node(pos: (1,1), value: text[\#undef], name: <B-binding>),
 partition-import-node(pos: (1, 2), kind: text[EXPLICIT], name: <B-part>),
 module-binding-def(module: <B>, name: <Bdot>),
 
 module-node(pos: (2,0), body: text[A], name: <A>),
 binding112-node(pos: (2,1), value: text[\#undef], name: <A-binding>),
 partition-node(pos: (2, 2), value: text[1], kind: text[CONST], name: <A-part>),
 module-binding-def(module: <A>, name: <Adot>),
 
 edge(<Maindot.center>, (rel: (0, 0.25), to: <Maindot.center>), (vertical: (), horizontal: <Main-binding.south>), <Main-binding.north>, "-|>", layer: 1),
 edge(<Bdot.center>, (rel: (0, 0.25), to: <Bdot.center>), (vertical: (), horizontal: <B-binding.south>), <B-binding.north>, "-|>", layer: 1),
 edge(<Adot.center>, (rel: (0, 0.25), to: <Adot.center>), (vertical: (), horizontal: <A-binding.south>), <A-binding.north>, "-|>", layer: 1),
 
 edge(<Main-binding-dot.center>, (rel: (0, 0.18), to: <Main-binding-dot.center>), (vertical: (), horizontal: <Main-part.north>), <Main-part.north>, "-|>", layer: 1),
 edge(<B-binding-dot.center>, (rel: (0, 0.18), to: <B-binding-dot.center>), (vertical: (), horizontal: <B-part.north>), <B-part.north>, "-|>", layer: 1),
 edge(<A-binding-dot.center>, (rel: (0, 0.18), to: <A-binding-dot.center>), (vertical: (), horizontal: <A-part.north>), <A-part.north>, "-|>", layer: 1),
 
 edge(<Main-part-restriction-dot.center>, (rel: (0.5, 0), to: <Main-part-restriction-dot.center>), (horizontal: (), vertical: <B-binding.west>), <B-binding.west>, "-|>", layer: 1),
 edge(<B-part-restriction-dot.center>, (rel: (0.5, 0), to: <B-part-restriction-dot.center>), (horizontal: (), vertical: <A-binding.west>), <A-binding.west>, "-|>", layer: 1)
),
)

#pagebreak()

= Julia 1.12: Implicitly Resolved Global

#grid(
  columns: (1.5fr, 2.5fr),
  column-gutter: 2em,
  align: horizon,
  
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mmodule A; x = 1; end

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mmodule B
           using ..A
           export x
       end

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0musing .B

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mx
1
", version: 1.12),
  
diagram(
 node-shape: rect,
 spacing: (1em, 1em),
 module-node(pos: (0,0), name: <Main>),
 binding112-node(pos: (0,1), value: text[\#undef], name: <Main-binding>),
 partition-import-node(pos: (0, 2), kind: text(size: 11pt)[IMPLICIT_GLOBAL], name: <Main-part>),
 module-binding-def(module: <Main>, name: <Maindot>),
 module-using-def(module: <Main>, ypos: 45%, name: <Mainusing>),
 
 module-node(pos: (1,0), body: text[B], name: <B>),
 binding112-node(pos: (1,1), value: text[\#undef], name: <B-binding>),
 partition-import-node(pos: (1, 2), kind: text(size: 11pt)[IMPLICIT_GLOBAL], name: <B-part>),
 module-binding-def(module: <B>, name: <Bdot>),
 module-using-def(module: <B>, ypos: 45%, name: <Busing>),
 
 module-node(pos: (2,0), body: text[A], name: <A>),
 binding112-node(pos: (2,1), value: text[\#undef], name: <A-binding>),
 partition-node(pos: (2, 2), value: text[1], kind: text[GLOBAL], name: <A-part>),
 module-binding-def(module: <A>, name: <Adot>),
 
 edge(<Mainusing.center>, (horizontal: <Mainusing.center>, vertical: <B.west>), <B.west>, "-|>", layer: 1),
 edge(<Busing.center>, (horizontal: <Busing.center>, vertical: <A.west>), <A.west>, "-|>", layer: 1),
 
 edge(<Maindot.center>, (rel: (0, 0.25), to: <Maindot.center>), (vertical: (), horizontal: <Main-binding.south>), <Main-binding.north>, "-|>", layer: 1),
 edge(<Bdot.center>, (rel: (0, 0.25), to: <Bdot.center>), (vertical: (), horizontal: <B-binding.south>), <B-binding.north>, "-|>", layer: 1),
 edge(<Adot.center>, (rel: (0, 0.25), to: <Adot.center>), (vertical: (), horizontal: <A-binding.south>), <A-binding.north>, "-|>", layer: 1),
 
 edge(<Main-binding-dot.center>, (rel: (0, 0.18), to: <Main-binding-dot.center>), (vertical: (), horizontal: <Main-part.north>), <Main-part.north>, "-|>", layer: 1),
 edge(<B-binding-dot.center>, (rel: (0, 0.18), to: <B-binding-dot.center>), (vertical: (), horizontal: <B-part.north>), <B-part.north>, "-|>", layer: 1),
 edge(<A-binding-dot.center>, (rel: (0, 0.18), to: <A-binding-dot.center>), (vertical: (), horizontal: <A-part.north>), <A-part.north>, "-|>", layer: 1),
 
 edge(<Main-part-restriction-dot.center>, "ddd", (rel: (1.5, 0), to: ()), (horizontal: (), vertical: <A-binding.west>), <A-binding.west>, "-|>", layer: 1),
 edge(<B-part-restriction-dot.center>, (rel: (0.7, 0), to: <B-part-restriction-dot.center>), (horizontal: (), vertical: <A-binding.west>), <A-binding.west>, "-|>", layer: 1)
),
)

#pagebreak()

= Julia 1.12: Implicitly Resolved Constant

#grid(
  columns: (1.5fr, 2.5fr),
  column-gutter: 2em,
  align: horizon,
  
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mmodule A; const x = 1; end

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mmodule B; const x = 1; end

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0musing .A, .B

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mx
1
", version: 1.12),
  
diagram(
 node-shape: rect,
 spacing: (1em, 1em),
 module-node(pos: (0,0), name: <Main>),
 binding112-node(pos: (0,1), value: text[\#undef], name: <Main-binding>),
 partition-node(pos: (0, 2), value: text[1], kind: text(size: 11pt)[IMPLICIT_CONST], name: <Main-part>),
 module-binding-def(module: <Main>, name: <Maindot>),
 module-using-def(module: <Main>, ypos: 35%, name: <Mainusing1>),
 module-using-def(module: <Main>, ypos: 55%, name: <Mainusing2>),
 
 module-node(pos: (1,0), body: text[A], name: <A>),
 binding112-node(pos: (1,1), value: text[\#undef], name: <A-binding>),
 partition-node(pos: (1, 2), value: text[1], kind: text[CONST], name: <A-part>),
 module-binding-def(module: <A>, name: <Adot>),
 
 module-node(pos: (2,0), body: text[B], name: <B>),
 binding112-node(pos: (2,1), value: text[\#undef], name: <B-binding>),
 partition-node(pos: (2, 2), value: text[1], kind: text[CONST], name: <B-part>),
 module-binding-def(module: <B>, name: <Bdot>),
 
 edge(<Mainusing1.center>, (horizontal: <Mainusing1.center>, vertical: <A.west>), <A.west>, "-|>", layer: 1),
 edge(<Mainusing2.center>, (horizontal: <Mainusing2.center>, vertical: <B.west>), <B.west>, "-|>", layer: 1),
 
 edge(<Maindot.center>, (rel: (0, 0.25), to: <Maindot.center>), (vertical: (), horizontal: <Main-binding.south>), <Main-binding.north>, "-|>", layer: 1),
 edge(<Adot.center>, (rel: (0, 0.25), to: <Adot.center>), (vertical: (), horizontal: <A-binding.south>), <A-binding.north>, "-|>", layer: 1),
 edge(<Bdot.center>, (rel: (0, 0.25), to: <Bdot.center>), (vertical: (), horizontal: <B-binding.south>), <B-binding.north>, "-|>", layer: 1),
 
 edge(<Main-binding-dot.center>, (rel: (0, 0.18), to: <Main-binding-dot.center>), (vertical: (), horizontal: <Main-part.north>), <Main-part.north>, "-|>", layer: 1),
 edge(<A-binding-dot.center>, (rel: (0, 0.18), to: <A-binding-dot.center>), (vertical: (), horizontal: <A-part.north>), <A-part.north>, "-|>", layer: 1),
 edge(<B-binding-dot.center>, (rel: (0, 0.18), to: <B-binding-dot.center>), (vertical: (), horizontal: <B-part.north>), <B-part.north>, "-|>", layer: 1),
 
 // No import edge for IMPLICIT_CONST - it copies the value instead
),
)

#pagebreak()


= Julia 1.12: Complex Using example

 // World age boundaries
 #let age_boundary(parttop, partbot, partleft, partright, body: text[], ..args) = {
  let mid = ((name: parttop, anchor: "south"), 50%, (name: partbot, anchor: "north"))
  return edge((horizontal: (name: partleft, anchor: "west"), vertical: mid),
       (horizontal: (name: partright, anchor: "east"), vertical: mid), layer: 1, snap-to: (none, none),
       "--", stroke: (paint: julia-red, thickness: 2pt, dash: "dashed"), label-side: left, label-pos: 50%, label: text(fill: julia-red, size: 9pt)[#body], ..args)
}


#grid(
  columns: (1.2fr, 2.8fr),
  column-gutter: 2em,
  align: horizon,
  
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mmodule A; global x; end

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0musing .A

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mCore.eval(A, :(const x = 1;))
1

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mx
1
", version: 1.12),
  
diagram(
 node-shape: rect,
 spacing: (3em, 0.48em),
 module-node(pos: (0,0), name: <Main>),
 binding112-node(pos: (0,1), value: text[\#undef], name: <Main-binding>),
 // Main partitions (newest to oldest, bottom to top)
 partition-node(pos: (0, 2), value: text[1], kind: text(size: 10pt)[IMPLICIT_CONST], height: 40pt, name: <Main-part3>),
 partition-import-node(pos: (0, 3), kind: text(size: 10pt)[IMPLICIT_GLOBAL], height: 40pt, name: <Main-part2>),
 partition-node(enclose: ((0, 4), (horizontal: (0, 5), vertical: <A-part1.south>)), pos: (0, 4.5), inset: 0pt, value: text[\#undef], kind: text[GUARD], name: <Main-part1>),
 module-binding-def(module: <Main>, name: <Maindot>),
 module-using-def(module: <Main>, ypos: 45%, name: <Mainusing>),
 
 module-node(pos: (1,0), body: text[A], name: <A>),
 binding112-node(pos: (1,1), value: text[\#undef], name: <A-binding>),
 // A partitions (newest to oldest, bottom to top)
 partition-node(pos: (1, 2), value: text[1], kind: text[CONST], height: 40pt, name: <A-part3>),
 partition-node(enclose: ((horizontal: (1, 3.5), vertical: <Main-part2.north>), (1,4)), inset: 0pt, pos: (1,4), value: text[\#undef], kind: text[DECLARED], height: 40pt, name: <A-part2>),
 partition-node(pos: (1, 5), value: text[\#undef], kind: text[GUARD], height: 40pt, name: <A-part1>),
 module-binding-def(module: <A>, name: <Adot>),

 node((0, 4), text[.], layer: -1),
 
 edge(<Mainusing.center>, (horizontal: <Mainusing.center>, vertical: <A.west>), <A.west>, "-|>", layer: 1),
 
 edge(<Maindot.center>, (rel: (0, 0.25), to: <Maindot.center>), (vertical: (), horizontal: <Main-binding.south>), <Main-binding.north>, "-|>", layer: 1),
 edge(<Adot.center>, (rel: (0, 0.25), to: <Adot.center>), (vertical: (), horizontal: <A-binding.south>), <A-binding.north>, "-|>", layer: 1),
 
 edge(<Main-binding-dot.center>, (rel: (0, 0.35), to: <Main-binding-dot.center>), (vertical: (), horizontal: <Main-part3.north>), <Main-part3.north>, "-|>", layer: 1),
 edge(<A-binding-dot.center>, (rel: (0, 0.35), to: <A-binding-dot.center>), (vertical: (), horizontal: <A-part3.north>), <A-part3.north>, "-|>", layer: 1),
 
 // Chain partitions (newest points to older)
 edge(<Main-part3-dot.center>, (rel: (0, 0.3), to: <Main-part3-dot.center>), (vertical: (), horizontal: <Main-part2.north>), <Main-part2.north>, "-|>", layer: 1),
 edge(<Main-part2-dot.center>, (rel: (0, 0.3), to: <Main-part2-dot.center>), (vertical: (), horizontal: <Main-part1.north>), <Main-part1.north>, "-|>", layer: 1),
 edge(<A-part3-dot.center>, (rel: (0, 0.3), to: <A-part3-dot.center>), (vertical: (), horizontal: <A-part2.north>), <A-part2.north>, "-|>", layer: 1),
 edge(<A-part2-dot.center>, (rel: (0, 0.3), to: <A-part2-dot.center>), (vertical: (), horizontal: <A-part1.north>), <A-part1.north>, "-|>", layer: 1),
 
 // Import edge from implicit global
 edge(<Main-part2-restriction-dot.center>, (rel: (0.5, 0), to: <Main-part2-restriction-dot.center>), (horizontal: (), vertical: <A-binding.west>), <A-binding.west>, "-|>", layer: 1),
 
 age_boundary(<Main-part3>, <Main-part2>, <Main-part3>, <A-part1>, body: text[const x = 1]),
 age_boundary(<Main-part2>, <Main-part1>, <Main-part3>, <A-part1>, body: text[using .A]),
 age_boundary(<A-part2>, <A-part1>, <Main-part3>, <A-part1>, body: text[global x]),
),
)

#pagebreak()

= Julia 1.12: Semantic Binding Resolution

#grid(
  columns: (1fr, 1fr),
  column-gutter: 2em,
  align: horizon,
  
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mmodule A; const x = 1; export x; end
Main.A

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0musing .A

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mf() = x
f (generic function with 1 method)

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mfor _ in [] x end

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mconst x = 2
2

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mf()
2
", version: 1.12),
  
  julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mmodule A; const x = 1; export x; end
Main.A

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0musing .A

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mf() = x
f (generic function with 1 method)

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mwhile false x end

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mconst x = 2
2

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mf()
2
", version: 1.12),
)

#v(1em)
#align(center)[
  #text(size: 18pt, weight: "bold", fill: julia-green)[Binding resolution now dependes exclusively on the set of  definitions at access time!]
]

#pagebreak()

= Julia 1.12: Binding Partition Kinds

#align(center)[
  #v(0.5em)
  #table(
    columns: (auto, 1fr),
    stroke: (x, y) => (
      left: if x > 0 { 1pt } else { 0pt },
      right: 0pt,
      top: if y == 0 { 2pt } else if y == 1 { 1pt } else { 0.5pt },
      bottom: if y == 11 { 1pt } else { 0.5pt },
    ),
    fill: (x, y) => if y == 0 { julia-purple.lighten(85%) } else if calc.even(y) { gray.lighten(95%) } else { white },
    align: (x, y) => if x == 0 { left } else { left },
    inset: (x, y) => if y == 0 { 8pt } else { 6pt },
    
    [*Partition Kind*], [*Description*],
    
    text(font: "JuliaMono", size: 14pt)[PARTITION_KIND_CONST], 
    [Constant declared using `const x = value` → restriction holds the constant value],
    
    text(font: "JuliaMono", size: 14pt)[PARTITION_KIND_CONST_IMPORT], 
    [Constant declared using `import A` → restriction holds the constant value],
    
    text(font: "JuliaMono", size: 14pt)[PARTITION_KIND_GLOBAL], 
    [Global variable declared via `global x::T` or assignment → restriction holds type],
    
    text(font: "JuliaMono", size: 14pt)[PARTITION_KIND_IMPLICIT_GLOBAL], 
    [Global implicitly imported from `using`'d module → restriction holds imported binding],
    
    text(font: "JuliaMono", size: 14pt)[PARTITION_KIND_IMPLICIT_CONST], 
    [Constant implicitly imported from `using`'d module → restriction holds constant value],
    
    text(font: "JuliaMono", size: 14pt)[PARTITION_KIND_EXPLICIT], 
    [Explicitly `using`'d by name → restriction holds imported binding],
    
    text(font: "JuliaMono", size: 14pt)[PARTITION_KIND_IMPORTED], 
    [Explicitly `import`'d by name → restriction holds imported binding],
    
    text(font: "JuliaMono", size: 14pt)[PARTITION_KIND_FAILED], 
    [Failed import due to ambiguity → restriction is NULL],
    
    text(font: "JuliaMono", size: 14pt)[PARTITION_KIND_DECLARED], 
    [Declared with `global` (weak, can be redefined) → restriction is NULL],
    
    text(font: "JuliaMono", size: 14pt)[PARTITION_KIND_GUARD], 
    [Looked at but no global/import resolved → restriction is NULL],
    
    text(font: "JuliaMono", size: 14pt)[PARTITION_KIND_UNDEF_CONST], 
    [Constant declared without value → restriction is NULL],
    
    text(font: "JuliaMono", size: 14pt)[PARTITION_KIND_BACKDATED_CONST], 
    [Backdated constant for compatibility (warns on access) → like CONST],
  )
]

= The `:latestworld` Mechanism

#grid(
  columns: (1fr, 1fr),
  column-gutter: 2em,
  
  block[
    #text(size: 11pt, weight: "bold")[\@latestworld]
    
    #julia-terminal("\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mconst x = 1
1

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mget_const() = x
get_const (generic function with 1 method)

\u{1b}[1m\u{1b}[32mjulia> \u{1b}[0m\u{1b}[0mbegin
           @show get_const()
           Core.eval(@__MODULE__, :(const x = 2))
           @show get_const()
           Core.@latestworld
           @show get_const()
       end
get_const() = 1
get_const() = 1
get_const() = 2
2", version: "1.12")
  ],
  
  block[
    #text(size: 11pt, weight: "bold")[Statements that Raise World Age]
    
    #text(size: 10pt)[
      The following raise the current world age:
    ]
    
    #text(size: 9pt)[
      #enum(
        tight: true,
        [An explicit invocation of `Core.@latestworld`],
        [The start of every top-level statement],
        [The start of every REPL prompt],
        [Any type or struct definition],
        [Any method definition],
        [Any constant declaration],
        [Any global variable declaration (but not a global variable assignment)],
        [Any `using`, `import`, `export` or `public` statement],
        [Certain other macros like `@eval` (depends on the macro implementation)],
      )
    ]
    
    #text(size: 10pt)[
      These make all changes visible to the current task.
    ]
  ]
)

#pagebreak()

#align(center + horizon)[
  #text(size: 56pt, fill: julia-purple, weight: "bold")[
    Thank You!
  ]
  
  #v(2em)
  
  #text(size: 28pt, fill: gray)[
    Questions?
  ]
  
  #v(3em)
  
  #text(size: 20pt)[
    Keno Fischer
    
    #link("mailto:keno@juliahub.com")[keno\@juliahub.com] • #box(baseline: 2pt)[#image("github-mark.svg", width: 16pt)] \@Keno
  ]
]