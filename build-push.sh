TAG=php-8-apache-20220525-1748

REPO=dlll-paas-base-image

docker build -t pudding/$REPO:$TAG .
docker push pudding/$REPO:$TAG