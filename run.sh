#!/usr/bin/env sh

echo "starting erftp"
echo "username=$username"
echo "password=$password"

adduser  -G sftp -D -H -s /bin/false $username
echo "$username:$password" | chpasswd
echo "$username:$(openssl passwd -salt erftp -crypt $password)" >> /etc/nginx/conf.d/htpasswd

if [[ ! -e /app/home ]]; then
    mkdir -pv /app/home /app/share /app/public
    chmod 777 /app/home /app/share /app/public
fi

nginx -c /etc/nginx/nginx.conf
/usr/sbin/sshd -D