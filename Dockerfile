FROM mcr.microsoft.com/devcontainers/base:bullseye

WORKDIR /app

ARG DEBIAN_FRONTEND=noninteractive

COPY zs.cer /etc/ssl/certs/zs.crt
COPY ./ruff.toml /app/.ruff.toml
COPY ./uv.toml /app/.uv.toml
COPY ./install_ohmyzsh.zsh /app/install_ohmyzsh.zsh
COPY ./.pre-commit-config.yml /app/.pre-commit-config.yml

# Set up python
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get full-upgrade -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && apt-get autoclean -y \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        python3-minimal \
        python3-pip \
        zsh \
        git \
        curl \
        vim \
        software-properties-common \
        build-essential \
        python3-dev \
    && rm -rf /var/lib/apt/lists/* \
    && echo "alias python=python3.12" >> /root/.zshrc \
    && echo "alias py=python3.12" >> /root/.zshrc \
    && echo "alias pip=pip3" >> /root/.zshrc

# Switch the shell to zsh
SHELL ["/bin/zsh", "-c"]


# Install zscalar certificates 
RUN mkdir -p /usr/local/share/ca-certificates/zs \
    && cp /etc/ssl/certs/zs.crt /usr/local/share/ca-certificates/zs/zs.crt \
    && update-ca-certificates

# Install oh-my-zsh
RUN chmod +x /app/install_ohmyzsh.zsh \
    && source /app/install_ohmyzsh.zsh  \
    && rm -rf /app/install_ohmyzsh.zsh

COPY ./.zshrc /root/zshrc

# Sync with uv / create venv (always ensure linter and pytest are installed)
RUN pip3 install uv \
    && uv init --lib \
    && echo "3.12" > /app/.python-version

# Download python 3.12 for uv
RUN add-apt-repository ppa:deadsnakes/ppa -y \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        python3.12 \
        python3.12-dev \
    && rm -rf /var/lib/apt/lists/*


# Install pre-commit hooks
# RUN pip install pre-commit \
#     && pre-commit install \
#     && pre-commit autoupdate

# Keep the container running
CMD ["tail", "-f", "/dev/null"]