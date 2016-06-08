FROM alpine
MAINTAINER smallweirdnum@gmail.com

# Install requirements
RUN apk add --no-cache \
        python-dev \
        py-pip \
        libstdc++ \
        mariadb-dev \
        postgresql-dev \
        py-cffi && \
    apk add --no-cache --virtual build-dependencies \
        musl-dev \
        gcc \
        make \
        cmake \
        g++ \
        gfortran && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    pip install \
        pandas==0.18.0 \
        MySQL-python==1.2.5 \
        psycopg2==2.6.1 \
        sqlalchemy-redshift==0.5.0 \
        caravel==0.9.0 && \
    apk del build-dependencies

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
