# Data Volume Container
FROM debian:wheezy

# VOLUME /opt/postgres

# The path is default of PostgreSQL official image as PGDATA.
# RUN groupadd -r postgres && useradd -r -g postgres postgres
# RUN mkdir -p /var/lib/postgresql/data && chown -R postgres /var/lib/postgresql/data
VOLUME /var/lib/postgresql/data

CMD /bin/bash
