# ------------------------------------------------------------------
# python        3.6    (apt)
# cuda  	9.0
# ==================================================================

FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
RUN APT_INSTALL="apt-get install -y --no-install-recommends" && \
    PIP_INSTALL="python -m pip --no-cache-dir install --upgrade" && \
    GIT_CLONE="git clone --depth 10" && \

    rm -rf /var/lib/apt/lists/* \
           /etc/apt/sources.list.d/cuda.list \
           /etc/apt/sources.list.d/nvidia-ml.list && \

    apt-get update && \

# ==================================================================
# tools
# ------------------------------------------------------------------

    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        build-essential \
        ca-certificates \
        cmake \
        wget \
	curl \
        git \
        vim \
	sudo \
	openssh-server \
        && \

# ==================================================================
# config & cleanup
# ------------------------------------------------------------------

    ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/*

# ==================================================================
# config ssh & create user
# ------------------------------------------------------------------
RUN sudo sed -i -e 's|PermitRootLogin prohibit-password|PermitRootLogin yes|' /etc/ssh/sshd_config && \
    sudo service ssh start && \
    echo root:123456 | chpasswd

# ARG User
# RUN useradd --no-log-init --shell /bin/bash $User && \
#    usermod -aG sudo $User && \
#    echo $User ALL=\(ALL\) NOPASSWD: ALL >> visudo 


