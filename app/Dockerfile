#Defined in the base image
FROM public.ecr.aws/lambda/python:3.11
# Set the working directory in the container
WORKDIR /app
# Copy the current directory contents into the container at /app
COPY requirements.txt .
COPY app.py .
# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
# Expose the port the app runs on
EXPOSE 80
# Command to run the app
CMD ["python", "app.py"]
