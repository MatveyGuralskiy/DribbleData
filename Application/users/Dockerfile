#---------------------------
# DribbleData Project
# Created by Matvey Guralskiy
#---------------------------

# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy only the requirements file first to leverage Docker cache
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container at /app
COPY . .

# Expose the port the app runs on
EXPOSE 5001

# Run Gunicorn server with 4 workers and 120 seconds timeout
CMD ["gunicorn", "--workers=4", "--timeout=120", "-b", "0.0.0.0:5001", "app:app"]
