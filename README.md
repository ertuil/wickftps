# wickftps

A simple docker container wich ftp(s), www, aria2 and ssh. It is a simple way to save your files.

## Deploy:

1. Git clone this resp (or just download `docker-compose.yml`)
2. Install `docker` and `docker-compose`
3. Config `docker-compose.yml`
4. Run `docker-compose up -d`
5. Config your firewalls to allow these ports: 20, 21, 3000-3010, 22(optional), 8080(optional), 6800(optional).

## Environments:

| Varibles | Default | Details |
| -------- | ------- | ------- | 
| USER_USERNAME | admin | username |
| USER_PASSWORD | password | password for the user |
| PASV_ADDRESS | none | the public internet address |
| PASV_MAX_PORT | 3010 | maxinum port for PASV mode |
| PASV_MIN_PORT | 3000 | maninum port for PASV mode |
| NGINX_ADDRESS | none | Nginx server_name |
| FTP_SSL | "false" | enable FTP SSL Mode |
| ENABLE_SSH | "false" | run ssh service |
| ENABLE_ARIA2 | "false" | run aria2 service |

## Usages

1. Web root is `/app/data/Shared/www`. Index is `http://<your_address>/`
2. Public sharable files can be placed in `/app/data/Shared/public`, it is visible publicly via `http://<your_address>/public`
3. Privatefiles can be placed in `/app/data/Shared/private`, it is visible via `http://<your_address>/private`. But `username` and `password` must be provided to access thses files.
4. Other files can be placed int `/app/data/Documents`, `/app/data/Pictures` and so on.
4. FTP control port is at 21, and passive mode needs 3000-3010 ports to be opened.
5. If ftps is enabled, use `Explicit FTPS Mode`.
6. If sshd is enabled, default port is 22. `Username` and `Password` are the same.
7. If aria2 is enabled, jsonrpc address is at `http://<your_address>/jsonrpc` and password is `USER_PASSWORD`