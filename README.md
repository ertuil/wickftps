# wickftps

A simple docker container wich ftp(s), www and ssh. It is a simple way to save your files.

## Usage:

1. Git clone this resp
2. Install `docker` and `docker-compose`
3. Config `docker-compose.yml`
4. Run `docker-compose up -d`
5. Config your firewalls to allow these ports

## Environments:

| Varibles | Default | Details |
| -------- | ------- | ------- | 
| USER_USERNAME | admin | username |
| USER_PASSWORD | password | password for the user |
| PASV_ADDRESS | none | the public internet address |
| PASV_MAX_PORT | 3010 | maxinum port for PASV mode |
| PASV_MIN_PORT | 3000 | maninum port for PASV mode |
| FTP_SSL | "false" | enable FTP SSL Mode |
| ENABLE_SSH | "false" | run ssh service |
