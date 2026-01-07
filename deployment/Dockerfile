FROM ollama/ollama:latest

# Copy the entrypoint script
COPY ./entrypoint.sh /entrypoint.sh

# Fix line endings (CRLF -> LF) for Windows compatibility
RUN sed -i 's/\r$//' /entrypoint.sh

# Make it executable
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
