#!/usr/bin/env sh

echo "starting erftp"

if [[ ! -e "/app/sftpusers" ]]; then
	touch /app/sftpusers
fi

if [[ ! -e "/app/sftp" ]]; then
	cp -rf /var/app/sftp /app
fi


for line in `cat /app/sftpusers`
do
    u=`echo $line | cut -d ':' -f1`
    p=`echo $line | cut -d ':' -f2`
    # if [[ -e  "/app/sftp/$u" ]]; then
    #     echo "skip user $u"
    #     continue
    # fi 
    echo "add user --> username: $u password: $p"
    adduser  -G sftp -D -H -s /bin/false $u
    echo "$u:$p" | chpasswd
    echo "$u:$(openssl passwd -salt erftp -crypt $p)" >> /etc/nginx/conf.d/htpasswd

    if [[ -e "/app/sftp/$u" ]]; then
        echo "skip mkdir for user $u"
        continue
    fi
    mkdir -pv /app/sftp/$u/home /app/sftp/$u/public /app/sftp/$u/share
    # chown root:sftp /app/sftp/$u
    # chown root:sftp /app/sftp/$u/home /app/sftp/$u/public
    chmod 777 /app/sftp/$u/home /app/sftp/$u/public /app/sftp/$u/share
done

nginx -c /etc/nginx/nginx.conf
/usr/sbin/sshd -D