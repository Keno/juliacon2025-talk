#!/usr/bin/env julia +1.12

# Script to reproduce the Julia 1.12 output shown in the presentation
# This demonstrates the struct redefinition fix in Julia 1.12

using REPL
using Revise

# Create a pseudo-TTY and REPL
pty = REPL.PseudoTerminal(false)
repl = REPL.LineEditREPL(pty, true)
repl.interface = REPL.setup_interface(repl)

# Helper to send commands
function send_command(cmd)
    write(pty.master, cmd * "\n")
    sleep(0.1)
end

# Start the REPL
t = @async REPL.run_repl(repl)

# Wait for REPL to be ready
sleep(1)

# Create initial struct file
write("struct.jl", """
struct Point
    x::Float64
    y::Float64
end
""")

# Send commands
println("Creating initial struct and instance...")
send_command("using Revise")
sleep(0.5)
send_command("includet(\"struct.jl\")")
sleep(0.5)
send_command("porig = Point(1.0, 2.0)")
sleep(0.5)

# Modify the struct file
println("\nModifying struct.jl to add z field...")
write("struct.jl", """
struct Point
    x::Float64
    y::Float64
    # New field!
    z::Float64
end
""")
sleep(1)  # Give Revise time to detect the change

# Try to create new instance and show old instance
println("\nCreating new instance and checking old instance...")
send_command("p = Point(1.0, 2.0, 3.0)")
sleep(0.5)
send_command("porig")
sleep(0.5)
send_command("# 🎉 It works!")
sleep(0.5)

# Clean up
send_command("exit()")
wait(t)

println("\nDone! The output shows how Julia 1.12 handles struct redefinitions with @world notation.")