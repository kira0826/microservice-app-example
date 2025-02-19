
FROM python:3.6-slim

WORKDIR /app

# Install build dependencies necesaries to install dependecies
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*


COPY requirements.txt .

#Install code dependecies.

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python3", "main.py" ]

