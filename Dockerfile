# ============================================================
# Base image: CUDA 11.2.2 with cuDNN 8 on Ubuntu 20.04
# ============================================================
FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    nano \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    git \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /app/film
COPY . /app/film

RUN python3 -m pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

RUN pip install -e .

# CMD ["python3", "main.py"]
