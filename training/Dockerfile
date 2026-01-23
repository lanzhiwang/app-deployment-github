FROM python:3.12.1-slim-bullseye

# 2. 环境变量设置
# PIP_NO_CACHE_DIR=1: 禁用 pip 缓存, 减少 pip 产生 pyc 文件并禁用缓存
# PYTHONUNBUFFERED=1: 实时输出日志, 方便 K8s 查看容器日志
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# 3. 设置工作目录 (会自动创建 /app 目录)
WORKDIR /app

# 4. 合并所有系统级操作在一层, 减少 Layer 数量并清理缓存
RUN set -eux; \
    # 安装必要的下载和解压工具
    apt-get update; \
    apt-get install -y --no-install-recommends curl unzip; \
    \
    # 获取架构信息
    dpkgArch="$(dpkg --print-architecture)"; \
    case "$dpkgArch" in \
    amd64) arch='amd64' ;; \
    arm64) arch='arm64' ;; \
    *) echo >&2 "error: unsupported arch: '$dpkgArch'"; exit 1 ;; \
    esac; \
    \
    # 下载并安装 ossutil
    URL="https://gosspublic.alicdn.com/ossutil/v2/2.2.0/ossutil-2.2.0-linux-${arch}.zip"; \
    curl -fL -o ossutil.zip "$URL"; \
    unzip ossutil.zip; \
    chmod +x "ossutil-2.2.0-linux-${arch}/ossutil"; \
    mv "ossutil-2.2.0-linux-${arch}/ossutil" /usr/local/bin/; \
    \
    # 立即清理 ossutil 临时文件
    rm -rf ossutil.zip "ossutil-2.2.0-linux-${arch}"; \
    \
    # 安装 Python 依赖
    pip install --upgrade pip; \
    # 注意：modelscope 依赖较多, 建议根据实际需求安装其子模块
    pip install modelscope==1.33.0 nacos-sdk-python==3.0.2 PyYAML==6.0.3 black==25.12.0; \
    \
    # 清理不再需要的系统工具和 apt 缓存
    apt-get purge -y --auto-remove curl unzip; \
    rm -rf /var/lib/apt/lists/*

# 5. 验证安装 (可选)
RUN ossutil version && python -c "import modelscope; print(modelscope.__version__)"
