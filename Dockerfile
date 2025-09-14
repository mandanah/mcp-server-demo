#Dockerfile
FROM python:3.11-slim
# Install uv (project manager)
RUN pip install --no-cache-dir uv
#Sets the working directory inside the container. After this, all relative paths (for COPY, RUN, CMD, etc.) are resolved relative to /app.
WORKDIR /app 
# 1) Copy ONLY the lock files first to leverage Docker cache
COPY pyproject.toml uv.lock /app/
# RUN → executes a command inside the image at build time (bakes results into a layer)
# --frozen = tells uv:
	# •	do not update or resolve new versions;
	# •	only install exactly what’s in uv.lock.
	# •	If the lockfile is missing or out-of-sync with pyproject.toml, the build fails.
RUN uv sync --frozen
COPY . /app
# Sets an environment variable inside the container: PORT=8000, Some platforms (Heroku, Render, etc.) overwrite PORT to tell your app which port to bind to.
ENV PORT 8000
# A metadata hint: says “this container listens on port 8000.”
# 	•	Doesn’t actually open a port — you still need docker run -p 8000:8000.
# 	•	Useful for documentation and orchestration tools (Kubernetes, Docker Compose).
EXPOSE 8000
# Run inside the uv-managed environment
CMD ["uv", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]