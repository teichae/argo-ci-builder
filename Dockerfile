FROM alpine:latest AS intermediate

#architecture 확인
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "aarch64" ]; then \
        echo "if aarch64"; \
        export ARCH_TYPE="arm64"; \
    else \
        echo "if x86_64"; \
        export ARCH_TYPE="amd64"; \
    fi && \
    echo ${ARCH_TYPE} > /tmp/arch_type.txt


#kustomize 최신 버전 확인
RUN apk --no-cache add curl && \
    curl -L https://api.github.com/repos/kubernetes-sigs/kustomize/releases/latest \
    | grep tag_name \
    | cut -d '"' -f 4 \
    | awk -F '/' '{print $2}' \
    | cut -c2- > /tmp/kustomize_version.txt

FROM alpine:latest

COPY --from=intermediate /tmp/arch_type.txt /tmp/arch_type.txt
COPY --from=intermediate /tmp/kustomize_version.txt /tmp/kustomize_version.txt

#kubectl, kustomize, helm, git, curl 설치
RUN ARCH_TYPE=$(cat /tmp/arch_type.txt) && \
    KUSTOMIZE_VER=$(cat /tmp/kustomize_version.txt) && \
    apk --no-cache add curl gettext py3-pip git helm tar yq && \
    curl -sLO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VER}/kustomize_v${KUSTOMIZE_VER}_linux_${ARCH_TYPE}.tar.gz && \
    tar xvzf kustomize_v${KUSTOMIZE_VER}_linux_${ARCH_TYPE}.tar.gz && \
    mv kustomize /usr/bin/kustomize && \
    chmod +x /usr/bin/kustomize && \
    rm kustomize_v${KUSTOMIZE_VER}_linux_${ARCH_TYPE}.tar.gz && \
    curl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/${ARCH_TYPE}/kubectl -o /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl && \
    curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 && \
    install -m 555 argocd-linux-amd64 /usr/local/bin/argocd && \
    rm argocd-linux-amd64 && \    
    pip3 install awscli --break-system-packages && \
    rm -rf /tmp
