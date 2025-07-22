# First, create struct.jl
write("struct.jl", """
struct Point
    x::Float64
    y::Float64
end
""")

# Initial setup
println("julia> using Revise")
using Revise

println("\njulia> includet(\"struct.jl\")")
includet("struct.jl")

println("\njulia> porig = Point(1.0, 2.0)")
porig = Point(1.0, 2.0)
println(porig)

println("\njulia> # Edit struct.jl...")

# Simulate file edit
write("struct.jl", """
struct Point
    x::Float64
    y::Float64
    # New field!
    z::Float64
end
""")

sleep(0.5)  # Give Revise time to detect the change

println("\njulia> p = Point(1.0, 2.0, 3.0)")
try
    p = Point(1.0, 2.0, 3.0)
    println(p)
    
    println("\njulia> porig")
    println(porig)
    
    println("\njulia> # 🎉 It works!")
catch e
    println("ERROR: ", e)
    println(sprint(showerror, e))
end