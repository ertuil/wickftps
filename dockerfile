FROM alpine:3.10.2
LABEL maintainer="ertuil"

ENV username=admin
ENV password=admin

EXPOSE 22 80
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk add --no-cache openssh-server nginx bash tzdata openssl && mkdir -pv /run/nginx
RUN addgroup sftp && mkdir -pv /app/home /app/share /app/public
RUN chmod -R 755 /app && chmod 777 /app/home /app/share /app/public

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    sed -i "s/Subsystem.*/Subsystem sftp internal-sftp/g" /etc/ssh/sshd_config && \
    ssh-keygen -t rsa -P "" -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -t ecdsa -P "" -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -t ed25519 -P "" -f /etc/ssh/ssh_host_ed25519_key

RUN echo "Match Group sftp">> /etc/ssh/sshd_config && \
    echo "passwordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "ForceCommand internal-sftp" >> /etc/ssh/sshd_config && \
    echo "ChrootDirectory /app" >> /etc/ssh/sshd_config && \
    echo "X11Forwarding no" >>  /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding no"  >> /etc/ssh/sshd_config 

ADD default.conf /etc/nginx/conf.d/default.conf
ADD run.sh /run.sh
RUN chmod +x /run.sh
WORKDIR /app

CMD [ "sh","-c","/run.sh"]