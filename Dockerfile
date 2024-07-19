FROM pytorch/pytorch:2.3.1-cuda12.1-cudnn8-devel

RUN apt-get update && apt-get install -y \
    curl

# Poetryをインストール
RUN curl -sSL https://install.python-poetry.org | python3 -

# Poetryのパスを設定
ENV PATH="/root/.local/bin:$PATH"

RUN poetry config virtualenvs.in-project true