docker rmi ertuil/erftp
docker build -t ertuil/erftp .
docker push ertuil/erftp
docker run -it --rm -p 2222:22 -p 8080:80 ertuil/erftp