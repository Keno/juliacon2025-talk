#!/bin/bash

# Create initial struct.jl
cat > struct.jl << 'EOF'
struct Point
    x::Float64
    y::Float64
end
EOF

# Use script to capture TTY session
script -q -c "julia +1.12 --startup-file=no" /dev/null << 'JULIA_COMMANDS'
using Revise
includet("struct.jl")
porig = Point(1.0, 2.0)
# Now we'll edit struct.jl
JULIA_COMMANDS

# Edit struct.jl
cat > struct.jl << 'EOF'
struct Point
    x::Float64
    y::Float64
    # New field!
    z::Float64
end
EOF

# Continue the session
script -q -c "julia +1.12 --startup-file=no" /dev/null << 'JULIA_COMMANDS2'
using Revise
includet("struct.jl")
p = Point(1.0, 2.0, 3.0)
porig
exit()
JULIA_COMMANDS2