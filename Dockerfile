FROM alpine AS builder
WORKDIR /root/
RUN apk update && apk upgrade && apk add curl bash openssl && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3  && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh

FROM alpine
COPY --from=builder /root/kubectl /usr/local/bin/helm /usr/local/bin/
RUN apk update && \
    apk upgrade && \
    apk add curl tcpdump socat python3 py-pip jq openssl openssh bash busybox-extras iperf ansible && \
    pip3 install --upgrade pip && \
    pip3 install awscli

CMD ["bash"]
