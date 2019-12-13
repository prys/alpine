FROM alpine AS builder
WORKDIR /root/
RUN apk update && apk upgrade && apk add curl bash openssl && \
    wget https://releases.hashicorp.com/vault/1.3.0/vault_1.3.0_linux_amd64.zip && \
    wget https://releases.hashicorp.com/consul/1.6.2/consul_1.6.2_linux_amd64.zip && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    unzip vault_1.3.0_linux_amd64.zip && \
    unzip consul_1.6.2_linux_amd64.zip && \
    rm consul_1.6.2_linux_amd64.zip && \
    rm vault_1.3.0_linux_amd64.zip && \
    chmod +x consul && \
    chmod +x vault && \
    chmod +x kubectl && \
    wget https://git.io/get_helm.sh && \
    chmod +x get_helm.sh && \
    ./get_helm.sh

FROM alpine
COPY --from=builder /root/consul /root/vault /root/kubectl /usr/local/bin/helm /usr/local/bin/
RUN apk update && \
    apk upgrade && \
    apk add curl tcpdump socat python3 jq openssl openssh bash busybox-extras iperf && \
    pip3 install --upgrade pip && \
    pip3 install awscli && \
    helm init --client-only

CMD ["bash"]
