docker rm -f erftp
docker rmi ertuil/erftp
docker build -t ertuil/erftp .
# docker push ertuil/erftp
docker run -d --name=erftp -p 2222:22 -p 8080:80 -v /Users/ertuil/Workspace/erftp/app:/app ertuil/erftp