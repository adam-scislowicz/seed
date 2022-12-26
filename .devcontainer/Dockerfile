FROM ubuntu:22.04

ENV UID=1000
ENV GID=1000
ARG USER

ENV AWSCDK_VERSION 2.55.1
ENV CLANG_VERSION 15
ENV EMSDK_VERSION 3.1.28
ENV GITLFS_VERSION 3.3.0
ENV GO_VERSION 1.19.4
ENV KIND_VERSION 0.17.0
ENV MINICONDA_VERSION py38_4.12.0
ENV MINIZINC_VERSION 2.6.4
ENV NEXTFLOW_VERSION 22.10.4
ENV NODEJS_VERSION 18.12.1
ENV NVM_VERSION v0.39.2
ENV PICO_SETUP_VERSION 04105e80201754f84cce38ac512558502d77bba6
ENV PYTHON_VERSION 3
ENV RUST_VERSION 1.65.0
ENV SOPS_VERSION 3.7.3

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /tmp

COPY requirements.txt /tmp/requirements.txt
COPY .gitconfig /tmp/.gitconfig

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get update \
    && apt-get install -y build-essential curl gnupg2 lsb-release software-properties-common \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 93C4A3FD7BB9C367 \
    && apt-add-repository "deb http://ppa.launchpad.net/ansible/ansible/ubuntu focal main" \
    && curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
    && curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null \
    && echo "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
    ansible \
    clangd \
    clang-format \
    cmake \
    debconf \
    direnv \
    dnsutils \
    docker-ce-cli \
    dstat \
    gcc-arm-none-eabi \
    git \
    google-cloud-cli \
    graphviz \
    htop \
    iproute2 \
    iputils-ping \
    kubeadm \
    kubectl \
    kubelet \
    kubernetes-cni \
    libboost-dev \
    libnewlib-arm-none-eabi \
    locales \
    ncat \
    neovim \
    nftables \
    netfilter-persistent \
    ninja-build \
    nmap \
    npm \
    openjdk-11-jdk \
    openssh-server \
    openssl \
    pkg-config \
    procps \
    pv \
    python$PYTHON_VERSION \
    python${PYTHON_VERSION}-pip \
    python${PYTHON_VERSION}-venv \
    rsync \
    slurm-wlm \
    socat \
    strace \
    sudo \
    terraform \
    telnet \
    tmux \
    tshark \
    tzdata \
    unzip \
    wget \
    && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen \
    && terraform -install-autocomplete \
    && curl -fsSL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip /tmp/awscliv2.zip \
    && ./aws/install \
    && curl -fsSL https://github.com/git-lfs/git-lfs/releases/download/v${GITLFS_VERSION}/git-lfs-linux-amd64-v${GITLFS_VERSION}.tar.gz -o \
        git-lfs-linux-amd64-v${GITLFS_VERSION}.tar.gz \
    && tar xvzf git-lfs-linux-amd64-v${GITLFS_VERSION}.tar.gz \
    && (cd git-lfs-${GITLFS_VERSION} && ./install.sh) \
    && curl -fsSL https://rclone.org/install.sh | bash \
    && curl -fsSL https://github.com/mozilla/sops/releases/download/v$SOPS_VERSION/sops_${SOPS_VERSION}_amd64.deb \
        -Lo sops_${SOPS_VERSION}_amd64.deb \
    && dpkg -i ./sops_${SOPS_VERSION}_amd64.deb \
    && curl -fsSL https://aka.ms/InstallAzureCLIDeb | bash \
    && curl -sS https://starship.rs/install.sh | sh -s -- --yes \
    && curl -fsSL https://apt.llvm.org/llvm.sh | bash -s -- $CLANG_VERSION \
    && curl -fsSL https://github.com/nextflow-io/nextflow/releases/download/v${NEXTFLOW_VERSION}/nextflow-${NEXTFLOW_VERSION}-all \
        -o /usr/local/bin/nextflow \
    && chmod 755 /usr/local/bin/nextflow \
    && curl -fsSL https://kind.sigs.k8s.io/dl/v${KIND_VERSION}/kind-linux-amd64 -o /usr/local/bin/kind \
    && chmod +x /usr/local/bin/kind \
    && groupadd -g $GID $USER \
    && useradd -l -g $USER -G sudo -u $UID -m $USER \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY postCreateCommand.sh /usr/local/bin

USER $USER
WORKDIR /home/$USER
ENV PATH="/home/${USER}/.nvm/versions/node/v${NODEJS_VERSION}/bin/:${PATH}"
ENV PICO_SDK_PATH=/home/$USER/pico/pico-sdk
ENV NVM_DIR=/home/$USER/.nvm
RUN curl https://raw.githubusercontent.com/raspberrypi/pico-setup/${PICO_SETUP_VERSION}/pico_setup.sh | SKIP_VSCODE=1 SKIP_UART=1 bash
RUN curl -L https://nixos.org/nix/install | bash -s -- --no-daemon \
    && curl -fsSL https://github.com/MiniZinc/MiniZincIDE/releases/download/${MINIZINC_VERSION}/MiniZincIDE-${MINIZINC_VERSION}-bundle-linux-x86_64.tgz \
        -o /tmp/MiniZincIDE-${MINIZINC_VERSION}-bundle-linux-x86_64.tgz \
    && curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash \
    && tar xvzf /tmp/MiniZincIDE-${MINIZINC_VERSION}-bundle-linux-x86_64.tgz \
    && echo "alias minizinc=\"LD_LIBRARY_PATH=/home/$USER/MiniZincIDE-${MINIZINC_VERSION}-bundle-linux-x86_64/lib:\$LD_LIBRARY_PATH /home/$USER/MiniZincIDE-${MINIZINC_VERSION}-bundle-linux-x86_64/bin/minizinc\"" \
        >> ~/.bashrc \
    && git clone https://github.com/emscripten-core/emsdk.git \
    && (cd emsdk; ./emsdk install $EMSDK_VERSION; ./emsdk activate $EMSDK_VERSION) \
    && curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -o /tmp/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh \
    && bash /tmp/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -s -- -b -p /home/$USER/miniconda/$MINICONDA_VERSION \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain $RUST_VERSION -y \
    && curl -fsSL https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz -o /tmp/go.tar.gz \
    && mkdir -p /home/$USER/go/$GO_VERSION \
    && tar -C /home/$USER/go/$GO_VERSION -xf /tmp/go.tar.gz --strip-components=1 \
    && echo export USER=$USER >> ~/.bashrc \
    && echo export PATH=/home/$USER/go/$GO_VERSION/bin:\$PATH >> ~/.bashrc \
    && echo source /home/$USER/.nix-profile/etc/profile.d/nix.sh >> ~/.bashrc \
    && echo eval \"\$\(direnv hook bash\)\" >> ~/.bashrc \
    && echo eval \"\$\(starship init bash\)\" >> ~/.bashrc \
    && pip3 install -r /tmp/requirements.txt \
    && . /home/$USER/.nvm/nvm.sh \
    && nvm install ${NODEJS_VERSION} \
    && nvm use ${NODEJS_VERSION} \
    && nvm alias default v${NODEJS_VERSION} \
    && echo source /home/$USER/.nvm/nvm.sh >> ~/.bashrc \
    && npm i -g aws-cdk@${AWS_CDK_VERSION} typescript \
    && cp /tmp/.gitconfig /home/$USER/.gitconfig \
    && echo /usr/local/bin/postCreateCommand.sh >> ~/.bashrc \
    && echo echo Load EMSDK: . /home/$USER/emsdk/emsdk_env.sh >> ~/.bashrc \
    && echo echo Load MiniConda: . /home/$USER/miniconda/${MINICONDA_VERSION}/etc/profile.d/conda.sh >> ~/.bashrc

#    && /tmp/MiniZincIDE-${MINIZINC_VERSION}-x86_64.AppImage install
#    && source ~/.bashrc && jupyter labextension install @jupyter-widgets/jupyterlab-manager ipygany

    RUN mkdir /home/user/seed
