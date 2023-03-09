FROM alpine
MAINTAINER  caldremch <finishmoend@gmail.cn>
# 安装 Docker CLI
USER root
RUN  mkdir -p /app/build
WORKDIR /app/build
COPY docker-latest.tgz .
COPY daemon_proccess.sh .
RUN  tar zxvf docker-latest.tgz \
    && cp docker/docker /usr/local/bin/ \
    && rm -rf docker docker-latest.tgz
# 将 `root` 用户的组 ID 改为宿主 `docker` 组的组ID，从而具有执行 `docker` 命令的权限。


ARG DOCKER_GID=994
USER root:${DOCKER_GID}



# 安装必要的依赖包
RUN apk add --no-cache curl tar gzip

COPY go1.18.2.linux-amd64.tar.gz /tmp/go.tar.gz

# 下载并解压 GoLand 安装包
RUN tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz 

# 设置环境变量
ENV PATH="/usr/local/go/bin:${PATH}"

VOLUME ['/app/build',"/var/run"]
#RUN docker images
RUN nohup daemon_proccess.sh &
#ENTRYPOINT [ "sh", "daemon_proccess.sh" ]