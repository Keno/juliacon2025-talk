# Reset struct.jl
write("struct.jl", """
struct Point
    x::Float64
    y::Float64
end
""")

# Capture REPL-like output
println("julia> using Revise")
using Revise

println("\njulia> includet(\"struct.jl\")")
includet("struct.jl")

println("\njulia> porig = Point(1.0, 2.0)")
porig = Point(1.0, 2.0)
println(repr(porig))

println("\njulia> # After editing struct.jl...")

# Edit the file
write("struct.jl", """
struct Point
    x::Float64
    y::Float64
    # New field!
    z::Float64
end
""")

# Force Revise to process changes
sleep(0.5)
Revise.revise()

println("\njulia> p = Point(1.0, 2.0, 3.0)")
p = Point(1.0, 2.0, 3.0)
println(repr(p))

println("\njulia> porig")
println(repr(porig))

println("\njulia> # 🎉 It works!")