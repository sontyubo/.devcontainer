# CUDAイメージ
FROM nvidia/cuda:11.8.0-devel-ubuntu20.04

# conda環境の構築
RUN apt-get update && \
    apt-get install -y \
    sudo \
    wget \
    vim \
    git \
    git-lfs && \
    git lfs install
    
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
    conda env create -n CartoonSegmentation -f conda_env.yml && \
    conda init bash && \
    conda config --set auto_activate_base false
    #echo "conda activate CartoonSegmentation" >> ~/.bashrc
    
# CONDA_DEFAULT_ENV：デフォルトの環境名,condaコマンドがデフォルトでこの仮想環境を指定する
# ENV PATH：環境内の python や pip などのコマンドがローカルより優先される
ENV CONDA_DEFAULT_ENV CartoonSegmentation && \
   PATH /opt/conda/envs/CartoonSegmentation/bin:$PATH

# -------------------------------------- #
# conda環境に入る（環境に入っていないとローカルのpipを呼び出す）
SHELL ["conda", "run", "-n", "CartoonSegmentation", "/bin/bash", "-c"]

# requirementsをコンテナ内に追加
COPY ./requirements.txt .

# その他のライブラリをインストール
RUN pip install torch==2.1.0 torchvision==0.16.0 torchaudio==2.1.0 --index-url https://download.pytorch.org/whl/cu118 

RUN pip install --upgrade pip && \
    pip install -f https://download.pytorch.org/whl/torch_stable.html torch==2.1.0+cu118 && \
    pip install -f https://download.pytorch.org/whl/torch_stable.html torchvision==0.16.0+cu118

RUN pip install -U openmim && \
    mim install "mmcv==2.1.0" mmdet mmengine && \
    pip install jupyter && \
    pip install -U "huggingface_hub[cli]" && \
    pip install -r requirements.txt && \
    git config --global --add safe.directory '/workspaces/CartoonSegmentation'
    #huggingface-cli lfs-enable-largefiles .

# SHELLを戻す
SHELL ["/bin/sh", "-c"]
# -------------------------------------- #

# コンテナを起動後、conda仮想環境に自動で入る
#WORKDIR $HOME/CartoonSegmentation
#CMD ["/bin/bash"]