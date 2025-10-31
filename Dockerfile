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

WORKDIR /app

ENV LABEL=atlas_training_1500

# CMD ["python3", "-m", "film.training.train", \
#      "--gin_config", "film/training/config/film_net-L1.gin", \
#      "--base_folder", "./experiments", \
#      "--label", ${LABEL}, \
#      "--mode", "gpu"]

# python3 -m film.training.train \
#   --gin_config film/training/config/film_net-L1.gin \
#   --base_folder ./experiments \
#   --label testtest
#   --mode gpu

# CMD ["bash", "-c", \
#      "python3 -m film.training.train \
#      --gin_config film/training/config/film_net-L1.gin \
#      --base_folder ./experiments \
#      --label ${LABEL} \
#      --mode gpu"]




# docker build -t film .
# docker run -d --gpus all --rm -v /mnt/neverland/itzo/frame-interpolation/experiments:/app/experiments -e LABEL=atlas_train_2500_steps_20000 -it film
