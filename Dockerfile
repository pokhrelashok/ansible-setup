FROM fedora:latest AS base
WORKDIR /usr/local/bin
ENV DNF_FLAGS=-y

RUN dnf update $DNF_FLAGS && \
    dnf clean all

RUN dnf install $DNF_FLAGS ansible && \
    dnf clean all && \
    dnf autoremove $DNF_FLAGS

FROM base AS main
ARG TAGS
RUN groupadd -g 1000 pokhrelashok2 && \
    useradd -g 1000 -u 1000 -m -s /bin/bash pokhrelashok2 && \
    echo 'pokhrelashok2 ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/pokhrelashok2
USER pokhrelashok2
WORKDIR /home/pokhrelashok2

FROM main
COPY . .
WORKDIR /home/pokhrelashok2
# COPY . /home/pokhrelashok2/ansible
# WORKDIR /home/pokhrelashok2/ansible
CMD ["sh", "-c", "ansible-playbook $TAGS install.yml --vault-password-file=vault_password.txt"]
