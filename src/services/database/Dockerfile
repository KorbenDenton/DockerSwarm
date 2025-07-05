FROM postgres:13-alpine

ENV POSTGRES_USER=postgres \
    POSTGRES_PASSWORD=postgres

COPY init.sql /docker-entrypoint-initdb.d/
