# 1. Base Image
# Using a 'slim' image for a smaller footprint. The readme specifies Python 3.10+, so 3.11 is a good, stable choice.
FROM python:3.13.4-alpine3.22

# 2. Set Environment Variables
# Prevents Python from writing .pyc files to disc (improves performance in container).
#ENV PYTHONDONTWRITEBYTECODE 1
# Prevents Python from buffering stdout and stderr (makes logs easier to see).
#ENV PYTHONUNBUFFERED 1

# 3. Set Working Directory
WORKDIR /app

# 4. Install Dependencies
# Copying requirements.txt first leverages Docker's layer caching.
# This layer is only rebuilt if requirements.txt changes.
COPY requirements.txt .
# no-cache-dir option prevents pip from caching the downloaded packages, reducing image size.
# This is important for production images to keep them lean.
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy Application Code
# .. copies all files from the current directory to the /app directory in the container.
# This includes the FastAPI app and any other necessary files.
COPY . .

# 6. Expose Port
# The application runs on port 8000 as per the uvicorn command.
# This makes the port available to the host machine.
# Exposing the port allows the host to access the FastAPI application. This port is from docker-compose.yml.
# If you change the port in your FastAPI app, make sure to update this line accordingly
EXPOSE 8000

# 7. Run Application
# The command to run the app in a production-like environment.
# Using 0.0.0.0 makes the app accessible from outside the container.
#CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
# Changing the command to use the `--reload` flag for development purposes.
# This allows the server to automatically reload when code changes, which is useful during development. This is on the official documentation.
# For production, you might want to remove the `--reload` flag.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]