FROM --platform=linux/amd64 mysql:5.7-debian

RUN apt-get update
RUN apt-get install -y wget

COPY add-server-id.sh /usr/local/bin/
COPY etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/
COPY etc/mysql/conf.d/mysql.cnf /etc/mysql/conf.d/
COPY prepare.sh /docker-entrypoint-initdb.d
COPY init-data.sh /usr/local/bin/
COPY sql /sql
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /usr/local/bin/add-server-id.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
