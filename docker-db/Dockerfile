FROM mysql/mysql-server:8.0

LABEL maintainer="seohands.com@gmail.com"

ARG MYSQL_ROOT_PASSWORD
ARG MYSQL_DATABASE_NAME
ARG MYSQL_USER_NAME
ARG MYSQL_USER_PASSWORD

# Створення бази даних
RUN echo "CREATE DATABASE ${MYSQL_DATABASE_NAME};" > /docker-entrypoint-initdb.d/01_create_database.sql

# Оновлений синтаксис для MySQL 8.0
RUN echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}'; \
          CREATE USER IF NOT EXISTS '${MYSQL_USER_NAME}'@'%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_USER_PASSWORD}'; \
          GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE_NAME}.* TO '${MYSQL_USER_NAME}'@'%'; \
          FLUSH PRIVILEGES;" > /docker-entrypoint-initdb.d/02_create_user.sql

# Копіювання та налаштування скрипта створення таблиць
COPY docker-db/setup_database.sql /setup_database.sql
RUN echo "USE ${MYSQL_DATABASE_NAME};" | cat - /setup_database.sql > /docker-entrypoint-initdb.d/03_setup_database.sql

# Налаштування MySQL
COPY docker-db/my.cnf /etc/my.cnf.d/my.cnf

EXPOSE 3306
