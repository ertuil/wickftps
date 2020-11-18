FROM alpine:latest
LABEL version="0.1" author="layton" email="layton.chen@outlook.com"
EXPOSE 20 21 22 3000-3010 80

RUN apk add  bash nginx vsftpd rsync openssl supervisor apache2-utils nginx-mod-http-fancyindex openssh-server aria2

WORKDIR /app
ADD ./etc/sshd_config /etc/ssh/sshd_config
ADD ./etc/nginx.conf /etc/nginx/nginx.conf
ADD ./etc/vsftpd.conf /etc/vsftpd/vsftpd.conf
ADD ./etc/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD ./etc/aria2.conf /etc/aria2.conf
ADD ./script/run.sh /bin/run.sh
RUN chmod +x /bin/run.sh

CMD [ "bash","-c","/bin/run.sh" ]