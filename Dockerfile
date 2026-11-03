# Builds the Celery image from the pinned API submodule (./backend)
FROM python:3.12-slim
WORKDIR /app
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY backend/ .
ENV PYTHONUNBUFFERED=1
CMD ["celery", "-A", "config", "worker", "-l", "INFO"]
