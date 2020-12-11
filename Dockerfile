FROM debian:buster

RUN apt-get update && apt-get -y upgrade \
&& apt-get install -y wget nano apt-utils nginx \
&& apt-get install -y mariadb-server mariadb-client \
&& apt-get install -y php7.3 php7.3-fpm php7.3-mysql php-common php7.3-cli php7.3-common php7.3-json php7.3-opcache php7.3-readline

COPY srcs/init.sh ./init.sh
COPY srcs ./srcs

CMD bash ./init.sh