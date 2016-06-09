FROM amancevice/pandas:0.18.0
MAINTAINER smallweirdnum@gmail.com

# Install requirements
RUN apk add --no-cache --virtual caravel-dependencies g++ && \
    apk add --no-cache \
        py-pip \
        mariadb-dev \
        postgresql-dev \
        py-cffi && \
    pip install \
        MySQL-python==1.2.5 \
        psycopg2==2.6.1 \
        sqlalchemy-redshift==0.5.0 \
        caravel==0.9.0 && \
    apk del caravel-dependencies

# Default config
ENV CSRF_ENABLED=1 \
    DEBUG=0 \
    PATH=$PATH:/home/caravel/bin \
    PYTHONPATH=/home/caravel:$PYTHONPATH \
    ROW_LIMIT=5000 \
    SECRET_KEY='\2\1thisismyscretkey\1\2\e\y\y\h' \
    SQLALCHEMY_DATABASE_URI=sqlite:////home/caravel/db/caravel.db \
    WEBSERVER_THREADS=8

# Run as caravel user
COPY caravel /home/caravel
RUN addgroup caravel && \
    adduser -h /home/caravel -G caravel -D caravel && \
    mkdir /home/caravel/db && \
    chown -R caravel:caravel /home/caravel
WORKDIR /home/caravel
USER caravel

EXPOSE 8088

CMD ["caravel", "runserver"]
