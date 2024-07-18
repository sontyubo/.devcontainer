# ベースイメージとして公式のPythonイメージを使用
FROM python:3.9-slim

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libffi-dev \
    libpq-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libgl1-mesa-glx \
    libglib2.0-0 \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Poetryをインストール
RUN curl -sSL https://install.python-poetry.org | python3 -

# Poetryのパスを設定
ENV PATH="/root/.local/bin:$PATH"

RUN poetry config virtualenvs.in-project true


# デフォルトの実行コマンド
# WORKDIR /semantic_seg
# COPY . /semantic_seg
# WORKDIR /semantic_seg/src
# CMD ["poetry", "run", "python", "sample.py"]