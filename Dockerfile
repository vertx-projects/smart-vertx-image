FROM alpine:3.15
MAINTAINER v_pengbo@foxmail.com
# 修改软件包源地址(此处使用 阿里云的源地址)
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
# -m表示自动建立用户家目录 -g指定用户所在的组,否则会建立一个同名的组(不指定)
RUN  addgroup -S smart && adduser -S smart -G smart -u 1234
# 更新软件包
RUN apk update upgrade && mkdir /app && mkdir -p /app/arthas && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
WORKDIR /app

COPY glibc-2.35-r1.apk glibc-2.35-r1.apk
COPY glibc-bin-2.35-r1.apk glibc-bin-2.35-r1.apk
COPY glibc-i18n-2.35-r1.apk glibc-i18n-2.35-r1.apk
COPY zlib-1_1.2.11-3-x86_64.pkg.tar zlib-1_1.2.11-3-x86_64.pkg.tar
COPY arthas/arthas-packaging-3.6.9.zip arthas-packaging-3.6.9.zip
COPY locale.md locale.md

RUN apk add --no-cache ca-certificates  jq curl gettext wget  && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN unzip -d arthas/ arthas-packaging-3.6.9.zip

RUN apk add glibc-2.35-r1.apk glibc-bin-2.35-r1.apk glibc-i18n-2.35-r1.apk
RUN mkdir -p libz && tar -xvf zlib-1_1.2.11-3-x86_64.pkg.tar -C libz && \
        mv libz/usr/lib/libz.so* /usr/glibc-compat/lib && \
        rm -rf *.apk && rm -rf /var/cache/apk/* && rm -rf libz/ &&  rm -rf *.tar && rm -rf *.zip

# tzdata 是可以配置时区,这里默认使用上海时区
RUN { echo '#!/bin/sh'; echo 'set -e'; echo; echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; } > /usr/local/bin/docker-java-home
RUN chmod +x /usr/local/bin/docker-java-home && \
    cat locale.md | tr -d '\r' | xargs -i /usr/glibc-compat/bin/localedef -i {} -f UTF-8 {}.UTF-8

# 以下为安装jdk 11 的命令 , 目前alpine:3.15 里面软件包最新版本 jdk版本 11.0.19
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/jvm/java-11-openjdk/jre/bin:/usr/lib/java-11-openjdk/bin
ENV HOME=/app
ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN.UTF-8
RUN apk add --no-cache openjdk11 && [ "$JAVA_HOME" = "$(docker-java-home)" ]

# 复制启动脚本
COPY start.sh /app
COPY listen_jvm.sh /app
RUN chmod +x start.sh listen_jvm.sh
RUN chown smart:smart /app/ -R

# 使用上述创建的用户
USER 1234

# 设置工作目录
ONBUILD WORKDIR /app
ONBUILD COPY ./target/*.jar app.jar

# 设置程序入口
ENTRYPOINT ["sh","/app/start.sh"]
