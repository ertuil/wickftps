1. 使用 http 访问文件时，public 和 share 文件夹下的内容可以公开，主页文件是 index.html 。
2. 使用 sftp 访问文件时，用户名、密码和端口请联系管理员。 
3. 用户根目录下修改文件夹和文件。 home 文件夹作为私密文件，对外需要认证。 
4. 管理员请配置 sftpusers 文件作为用户文件配置。 
5. docker 中的 nginx 端口是 80 ，ssh 端口是 22 。 
6. docker run example:  docker run -d --name=erftp -p 2222:22 -p 8080:80 -vhost/app:/app ertuil/erftp -e username=ertuil -e password=xxxxxx