using REPL
using REPL.TerminalMenus

# Create initial struct.jl
write("struct.jl", """
struct Point
    x::Float64
    y::Float64
end
""")

# Function to simulate REPL input
function simulate_repl()
    # Create a pseudo TTY
    input = Base.PipeEndpoint()
    output = IOBuffer()
    
    repl = REPL.LineEditREPL(REPL.Terminals.TTYTerminal("", input, output, output), true)
    
    # Commands to execute
    commands = [
        "using Revise",
        "includet(\"struct.jl\")",
        "porig = Point(1.0, 2.0)",
        "# Now editing struct.jl...",
    ]
    
    for cmd in commands
        write(input, cmd * "\n")
    end
    
    # Edit the file
    write("struct.jl", """
struct Point
    x::Float64
    y::Float64
    # New field!
    z::Float64
end
""")
    
    # More commands after edit
    commands2 = [
        "p = Point(1.0, 2.0, 3.0)",
        "porig",
        "# 🎉 It works!",
    ]
    
    for cmd in commands2
        write(input, cmd * "\n")
    end
    
    # Run the REPL
    REPL.run_repl(repl)
end

simulate_repl()