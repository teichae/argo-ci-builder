# argo-ci-builder

해당 프로젝트는 Argo Workflow 사용 시 CI/CD를 편하게 사용하고자 cli 도구를 묶어논 Dockerfile 입니다.

~~최대한 가볍게 만들고자 했지만.. 패키지가 점점 추가되어 의미가 퇴색되어 가는 중입니다.~~

## 목차
- [설치](#설치)
- [사용법](#사용법)
- [변경 로그](#변경-로그)
  - [버전 3.0](#버전-30)
  - [버전 2.0](#버전-20)
  - [버전 1.0](#버전-10)

## 설치
git clone 하여 Dockerfile 을 다운로드 후 docker build 를 사용하여 빌드하면 되거나..

docker pull ghcr.io/teichae/argo-ci-builder:버전 을 이용하여 이미지를 불러와서 사용하면 됩니다.

```sh
# 리포지토리 클론
git clone https://github.com/teichae/argo-ci-builder

# 프로젝트 디렉토리로 이동
cd argo-ci-builder

# Docker 이미지 빌드
docker build -t argo-ci-builder .
```

## 사용법

```sh
#docker 사용 시
docker run -it --rm  ghcr.io/teichae/argo-ci-builder:3.0 sh
```

Bash가 없기 때문에 sh를 사용합니다.

## 버전 3.0
ArgoCD CLI를 추가하였습니다.


## 버전 2.0
yq와 pip 사용 문제로 --break-system-packages 옵션 추가

## 버전 1.0
kubectl, kustomize, helm, awscli, curl, git 등 필요한 패키지를 통합
