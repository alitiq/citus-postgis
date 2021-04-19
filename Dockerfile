FROM citusdata/citus:pg12

MAINTAINER Daniel Lassahn <daniel.lassahn@meteointelligence.de>

RUN apt update
RUN apt -yqq upgrade

RUN apt-get -yqq install gnupg2 wget
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt-get install -yqq postgis postgresql-12-postgis-3