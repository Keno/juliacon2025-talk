#!/usr/bin/env python3
import http.server
import socketserver
import os

PORT = 8000
os.chdir('/workspace/juliacon-2025-constants-talk')

Handler = http.server.SimpleHTTPRequestHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Server running at http://localhost:{PORT}/")
    print(f"View slides at http://localhost:{PORT}/slides/presentation.md")
    httpd.serve_forever()