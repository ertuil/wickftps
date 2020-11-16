#!/bin/sh

# step 1: set up users
USERNAME=${USER_USERNAME:-"admin"}
PASSWORD=${USER_PASSWORD:-"password"}
echo "create user:" $USERNAME $PASSWORD
adduser -H -h /app/www -s /bin/bash $USERNAME 
echo $USERNAME:$PASSWORD | chpasswd 

#  step 2: set up work directory
if [ ! -e /app/www -o ! -e /app/conf ]; then
    echo "build work directory"
    mkdir -p /app/www/Shared/www /app/www/Shared/private /app/www/Shared/public /app/conf
    mkdir -p /app/www/Documents /app/www/Music /app/www/Movie /app/www/Pictures /app/www/Downloads 
fi
chown -R $USERNAME:$USERNAME /app/www 

# step 3: set up nginx
echo "set up nginx" 
htpasswd -c -b /etc/nginx/htpasswd $USERNAME $PASSWORD 
echo "user ${USERNAME};" >> /etc/nginx/nginx.conf

# step 4: set up vsftpd
echo "set up vsftpd"
if [ ! -z "${PASV_ADDRESS}" ]; then
    echo "pasv_address=${PASV_ADDRESS}" >> /etc/vsftpd/vsftpd.conf
fi
echo "pasv_max_port=${PASV_MAX_PORT:-3010}" >> /etc/vsftpd/vsftpd.conf
echo "pasv_min_port=${PASV_MIN_PORT:-3000}" >> /etc/vsftpd/vsftpd.conf

if [ ! -z "${FTP_SSL}" ]; then
    echo "set up ssl for ftp"
    if [ ! -e /app/conf/key.pem -o ! -e /app/conf/cert.pem ]; then
        echo "generate new certificates"
        openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -subj "/C=US/ST=MA/L=Boston/CN=${PASV_ADDRESS}" -keyout /app/conf/key.pem -out /app/conf/cert.pem 
    fi
    echo "rsa_private_key_file=/app/conf/key.pem" >> /etc/vsftpd/vsftpd.conf
    echo "rsa_cert_file=/app/conf/cert.pem" >> /etc/vsftpd/vsftpd.conf

    cat << EOF >> /etc/vsftpd/vsftpd.conf
ssl_enable=YES
ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=NO
ssl_ciphers=HIGH
EOF
fi

# step 5: set up sshd
if [ ! -z "$ENABLE_SSH" ]; then
    echo "set up openssh" 
    if [ ! -e /app/conf/ssh_host_rsa_key ]; then
        ssh-keygen -t rsa -f /app/conf/ssh_host_rsa_key
        chmod 600 /app/conf/ssh_host_rsa_key
    fi
    if [ ! -e /app/conf/ssh_host_ecdsa_key ]; then
        ssh-keygen -t ecdsa -f /app/conf/ssh_host_ecdsa_key
        chmod 600 /app/conf/ssh_host_ecdsa_key
    fi
    cat << EOF >> /etc/supervisor/conf.d/supervisord.conf
[program:ssh]
command=/usr/sbin/sshd -D
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0
autorestart=true
startretries=5
EOF
fi

#
echo "start all services"
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
