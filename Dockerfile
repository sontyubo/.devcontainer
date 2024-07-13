# ベースイメージとしてUbuntuを使用
FROM ubuntu:22.04

# パッケージリストを更新し、基本的なツールをインストール
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    curl \
    wget \
    vim \
    git \
    && apt-get clean

# タイムゾーンを設定
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 作業ディレクトリの設定
WORKDIR /workspace

# コンテナが起動したときに実行されるコマンド（bashを起動）
# CMD ["bash"]