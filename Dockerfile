FROM debian:10-slim

RUN apt-get update && \
    apt-get -y install gpg && \
    rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

RUN KEYS=( \
        E1A5C593CD419DE28E8315CF3C2525ED14360CDE \
        CEACC9E15534EBABB82D3FA03353C9CEF108B584 \
        16ACFD5FBD34880E584ECD2975E9CA927C18C076 \
        8695A8BFD3F97CDAAC35775A9CA4ABB381AB73C8 \
    ); \
  (gpg --keyserver pgp.mit.edu --recv-keys ${KEYS[@]}; echo "pgp.mit.edu done") &  \
  sleep 1s; \
  (gpg --keyserver keyserver.pgp.com --recv-keys ${KEYS[@]}; echo "keyserver.pgp.com done") &  \
  (gpg --keyserver ha.pool.sks-keyservers.net --recv-keys ${KEYS[@]}; echo "ha.pool.sks-keyservers.net") &  \
  (gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys ${KEYS[@]}; echo "hkp://p80.pool.sks-keyservers.net:80") &  \
  wait -n && \
  gpg --list-keys

RUN gpg --list-keys
