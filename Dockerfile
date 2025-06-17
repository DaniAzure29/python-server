# Use official Python base image
FROM python:3.12-slim

# Set working directory inside the container
WORKDIR /app

# Copy your app code into the container
COPY server.py .

# Expose port 8080 to the outside world
EXPOSE 8080

# Run the app
CMD ["python", "server.py"]
