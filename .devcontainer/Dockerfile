FROM ubuntu:20.04

ENV UID=1000
ENV GID=1000
ARG USER

ENV CLANG_VERSION 15
ENV GO_VERSION 1.19.2
ENV RUST_VERSION 1.64.0
ENV EMSDK_VERSION 3.1.24
ENV SOPS_VERSION 3.7.3
ENV PYTHON_VERSION 3
ENV MINICONDA_VERSION py38_4.12.0

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /tmp

COPY requirements.txt /tmp/requirements.txt
COPY .gitconfig /tmp/.gitconfig

RUN apt-get update \
    && apt-get install -y curl gnupg2 lsb-release software-properties-common \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 93C4A3FD7BB9C367 \
    && apt-add-repository "deb http://ppa.launchpad.net/ansible/ansible/ubuntu focal main" \
    && curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && apt-get update \
    && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ansible \
    clangd \
    clang-format \
    cmake \
    debconf \
    direnv \
    dnsutils \
    dstat \
    gcc-arm-none-eabi \
    git \
    google-cloud-cli \
    graphviz \
    htop \
    iproute2 \
    kubectl \
    libboost-dev \
    libnewlib-arm-none-eabi \
    locales \
    ncat \
    neovim \
    nftables \
    netfilter-persistent \
    ninja-build \
    nmap \
    openssh-server \
    openssl \
    pkg-config \
    procps \
    pv \
    python$PYTHON_VERSION \
    python${PYTHON_VERSION}-pip \
    python${PYTHON_VERSION}-venv \
    rsync \
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
    && curl -fsSL https://rclone.org/install.sh | bash \
    && curl -fsSL https://github.com/mozilla/sops/releases/download/v$SOPS_VERSION/sops_${SOPS_VERSION}_amd64.deb \
        -Lo sops_${SOPS_VERSION}_amd64.deb \
    && dpkg -i ./sops_${SOPS_VERSION}_amd64.deb \
    && curl -fsSL https://aka.ms/InstallAzureCLIDeb | bash \
    && curl -sS https://starship.rs/install.sh | sh -s -- --yes \
    && curl -fsSL https://apt.llvm.org/llvm.sh | bash -s -- $CLANG_VERSION \
    && groupadd -g $GID $USER \
    && useradd -l -g $USER -G sudo -u $UID -m $USER \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER $USER
WORKDIR /home/$USER
#ENV PICO_SDK_PATH=/home/$USER/pico/pico-sdk
#RUN curl https://raw.githubusercontent.com/raspberrypi/pico-setup/master/pico_setup.sh | SKIP_VSCODE=1 SKIP_UART=1 bash
RUN curl -L https://nixos.org/nix/install | bash -s -- --no-daemon \
    && git clone https://github.com/emscripten-core/emsdk.git \
    && (cd emsdk; ./emsdk install $EMSDK_VERSION; ./emsdk activate $EMSDK_VERSION) \
    && curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -o /tmp/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh \
    && bash /tmp/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -s -- -b -p /home/$USER/miniconda/$MINICONDA_VERSION \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain $RUST_VERSION -y \
    && curl -fsSL https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz -o /tmp/go.tar.gz \
    && mkdir -p /home/$USER/go/$GO_VERSION \
    && tar -C /home/$USER/go/$GO_VERSION -xf /tmp/go.tar.gz --strip-components=1 \
    && echo export USER=$USER >> ~/.bashrc \
    && echo export PATH=\$PATH:/home/$USER/go/$GO_VERSION/bin >> ~/.bashrc \
    && echo source /home/$USER/.nix-profile/etc/profile.d/nix.sh >> ~/.bashrc \
    && echo eval \"\$\(direnv hook bash\)\" >> ~/.bashrc \
    && echo eval \"\$\(starship init bash\)\" >> ~/.bashrc \
    && echo source /home/$USER/emsdk/emsdk_env.sh >> ~/.bashrc \
    && echo source /home/$USER/miniconda/${MINICONDA_VERSION}/etc/profile.d/conda.sh >> ~/.bashrc \
    && pip3 install -r /tmp/requirements.txt \
    && cp /tmp/.gitconfig /home/$USER/.gitconfig

#    && source ~/.bashrc && jupyter labextension install @jupyter-widgets/jupyterlab-manager ipygany

    RUN mkdir /home/user/seed
