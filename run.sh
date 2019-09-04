#!/usr/bin/env sh
for line in `cat /app/sftpusers`
do
    u=`echo $line | cut -d ':' -f1`
    p=`echo $line | cut -d ':' -f2`
    adduser  -G sftp -D -H -s /bin/false $u
    echo "$u:$p" | chpasswd
    mkdir -pv /app/sftp/$u/home /app/sftp/$u/public
    # chown root:sftp /app/sftp/$u
    # chown root:sftp /app/sftp/$u/home /app/sftp/$u/public
    chmod 777 /app/sftp/$u/home /app/sftp/$u/public
done

nginx -c /etc/nginx/nginx.conf
/usr/sbin/sshd
/bin/bash