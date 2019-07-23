FROM mysql:5.6

COPY ./custom.cnf /etc/mysql/conf.d/custom.cnf
COPY ./*.sql /docker-entrypoint-initdb.d/

RUN chmod 0644 /etc/mysql/conf.d/custom.cnf

ENV MYSQL_ROOT_PASSWORD root123
