using Pkg
Pkg.activate(temp=true)
Pkg.add("Revise")

# Create struct.jl
write("struct.jl", """
struct Point
    x::Float64
    y::Float64
end
""")

# Start with Revise
using Revise

# Track the file
Revise.includet("struct.jl")

# Create an instance
porig = Point(1.0, 2.0)
println("Created porig = ", porig)

# Now modify the file
println("\nModifying struct.jl to add z field...")
write("struct.jl", """
struct Point
    x::Float64
    y::Float64
    # New field!  
    z::Float64
end
""")

# Wait for Revise to pick up changes
sleep(1)
Revise.revise()

# Try to create new instance
println("\nTrying to create Point(1.0, 2.0, 3.0)...")
try
    p = Point(1.0, 2.0, 3.0)
    println("Success! p = ", p)
    println("Original porig = ", porig)
catch e
    println("Error: ", e)
end