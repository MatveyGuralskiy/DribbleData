#---------------------------
# DribbleData Project
# Created by Matvey Guralskiy
#---------------------------

# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install Gunicorn
RUN pip install gunicorn

# Expose the port the app runs on
EXPOSE 5003

# Run Gunicorn server
CMD ["gunicorn", "-b", "0.0.0.0:5003", "app:app"]

