# CUDAイメージ
FROM nvidia/cuda:11.8.0-devel-ubuntu20.04

# タイムゾーンの自動選択を有効化_dockerでは対話式の設定が不可
ENV DEBIAN_FRONTEND=noninteractive
# メモリの断片化を避ける
ENV PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True

# Linuxの構築
RUN apt-get update && \
    apt-get install -y \
    sudo \
    wget \
    vim \
    git \
    tzdata \
    libgl1-mesa-glx \
    libglib2.0-0
    
WORKDIR /opt

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    sh Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3 && \
    rm -r Miniconda3-latest-Linux-x86_64.sh

ENV PATH /opt/miniconda3/bin:$PATH

COPY ./.devcontainer/conda_env.yml .

# conda env createは、conda_env.ymlの内容を修正して実行可能になった
# condaからpytorchを入れるのをやめる
# python3.10をconda.ymlから指定
# init bashに変更
RUN conda update -n base -c defaults conda && \
    conda env create -n Paints-UNDO -f conda_env.yml && \
    conda init bash && \
    conda config --set auto_activate_base false
    #echo "conda activate Paints-UNDO" >> ~/.bashrc
    
# CONDA_DEFAULT_ENV：デフォルトの環境名,condaコマンドがデフォルトでこの仮想環境を指定する
# ENV PATH：環境内の python や pip などのコマンドがローカルより優先される
ENV CONDA_DEFAULT_ENV Paints-UNDO && \
    PATH /opt/conda/envs/Paints-UNDO/bin:$PATH

# -------------------------------------- #
# conda環境に入る（環境に入っていないとローカルのpipを呼び出す）
SHELL ["conda", "run", "-n", "Paints-UNDO", "/bin/bash", "-c"]

# requirementsをコンテナ内に追加
COPY ./requirements.txt .

# その他のライブラリをインストール
RUN pip install --upgrade pip && \
    pip install -f https://download.pytorch.org/whl/torch_stable.html torch==2.1.0+cu118 && \
    pip install -f https://download.pytorch.org/whl/torch_stable.html torchvision==0.16.0+cu118 && \
    pip install -f https://raw.githubusercontent.com/facebookresearch/xformers/main/wheels/cu118_pyt210/index.html xformers

# xformers 削除 
RUN pip install ipykernel && \
    pip install -r requirements.txt

# SHELLを戻す
SHELL ["/bin/sh", "-c"]
# -------------------------------------- #

# コンテナを起動後、conda仮想環境に自動で入る
#WORKDIR $HOME/Paints-UNDO
#CMD ["/bin/bash"]