FROM pytorch/pytorch:2.5.1-cuda12.1-cudnn9-devel
# FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

ENV PATH /opt/conda/bin:$PATH

CMD [ "/bin/bash" ]

# Leave these args here to better use the Docker build cache
ARG CONDA_VERSION=py312_26.1.1-1
# hadolint ignore=DL3008
RUN set -x && apt-get update -q && \
    apt-get install -q -y --no-install-recommends \
    bzip2 \
    ca-certificates \
    git \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    mercurial \
    procps \
    subversion \
    wget \
    vim \
    openssh-client \
    openssh-server \
    systemd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    UNAME_M="$(uname -m)" && \
    if [ "${UNAME_M}" = "x86_64" ]; then \
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh"; \
    SHA256SUM="eef1283cdc9d37f55743778ea4567e91aa28c2e3be4adab529dda324c3c897a2"; \
    elif [ "${UNAME_M}" = "aarch64" ]; then \
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-aarch64.sh"; \
    SHA256SUM="0a84d50ec92fbb248e31bff0a5888bf2f4dc322fc979e94ecc6e9946d0324ce7"; \
    fi && \
    wget "${MINICONDA_URL}" -O miniconda.sh -q && \
    echo "${SHA256SUM} miniconda.sh" > shasum && \
    if [ "${CONDA_VERSION}" != "latest" ]; then sha256sum --check --status shasum; fi && \
    mkdir -p /opt && \
    bash miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh shasum && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    /opt/conda/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r && \
    /opt/conda/bin/conda install -n base --yes jupyter_core notebook jupyterhub jupyterlab && \
    # /opt/conda/bin/conda install -n base --yes pytorch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1 pytorch-cuda=12.1 -c pytorch -c nvidia && \
    # /opt/conda/bin/pip install --index-url https://download.pytorch.org/whl/cu121 torch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1 && \
    # /opt/conda/bin/pip install --index-url https://download.pytorch.org/whl/cu121 torch==2.5.1 && \
    /opt/conda/bin/pip cache purge && \
    /opt/conda/bin/conda clean -afy && \
    mkdir -p /run/sshd && \
    chmod 0755 /run/sshd

# docker run -ti --rm \
# --gpus '"device=6, 7"' \
# --ulimit memlock=-1:-1 \
# --ulimit stack=67108864 \
# --security-opt seccomp=unconfined \
# -e NVIDIA_DRIVER_CAPABILITIES=all \
# -e OMP_NUM_THREADS=1 \
# -e MKL_NUM_THREADS=1 \
# -e OPENBLAS_NUM_THREADS=1 \
# pytorch/pytorch:2.5.1-cuda12.1-cudnn9-devel bash
