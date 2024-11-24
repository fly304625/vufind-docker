services:
  vufind-database:
    container_name: ${DB_HOST_NAME}
    build:
      context: .
      dockerfile: docker-db/Dockerfile
      args:
        MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
        MYSQL_DATABASE_NAME: ${DB_NAME}
        MYSQL_USER_NAME: ${DB_USER_NAME}
        MYSQL_USER_PASSWORD: ${DB_USER_PASSWORD}
    environment:
      MYSQL_ROOT_PASSWORD: "${DB_ROOT_PASSWORD}"
      MYSQL_DATABASE: "${DB_NAME}"
      MYSQL_USER: "${DB_USER_NAME}"
      MYSQL_PASSWORD: "${DB_USER_PASSWORD}"
    ports:
      - "3366:3306"
    volumes:
      - ./docker-db/data:/var/lib/mysql
      - ./docker-db/my.cnf:/etc/mysql/conf.d/my.cnf
    networks:
      - network_1
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p${DB_ROOT_PASSWORD}"]
      interval: 10s
      timeout: 5s
      retries: 5

  vufind-application:
    container_name: vufind_app
    build:
      context: .
      dockerfile: docker-application/Dockerfile
    environment:
      LOCAL_SOLR: ${LOCAL_SOLR}
      LOCAL_SOLR_USE_SAMPLE_DATA: ${LOCAL_SOLR_USE_SAMPLE_DATA}
      MYSQL_HOST_NAME: ${DB_HOST_NAME}
      MYSQL_DATABASE_NAME: ${DB_NAME}
      MYSQL_USER_NAME: ${DB_USER_NAME}
      MYSQL_USER_PASSWORD: ${DB_USER_PASSWORD}
      XDEBUG_MODE: develop,debug
      XDEBUG_CLIENT_HOST: host.docker.internal
      XDEBUG_CLIENT_PORT: 9000
      XDEBUG_START_WITH_REQUEST: yes
      PYTHONUNBUFFERED: 1
    depends_on:
      vufind-database:
        condition: service_healthy
    ports:
      - "8000:80"
      - "8001:8080"
    volumes:
      - ./vufind:/usr/local/vufind
      - ./vufind-configs:/usr/local/vufind-configs
      - ./sample-data:/import
    networks:
      - network_1

networks:
  network_1:
    name: vufind_network
