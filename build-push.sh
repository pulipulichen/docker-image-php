#TAG=php-8-apache-20220616-1816
TAG=php-7.2-apache-20220616-2220

REPO=dlll-paas-base-image

docker build -t pudding/$REPO:$TAG .
docker push pudding/$REPO:$TAG
docker rmi pudding/$REPO:$TAG