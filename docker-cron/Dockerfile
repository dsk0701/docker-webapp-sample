FROM postgres:9.3

# Add script file to /
COPY data_backup.sh /data_backup.sh

# Give execution rights
RUN chmod +x /data_backup.sh

# Add crontab file in the cron directory
ADD crontab /etc/cron.d/crontab

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/*

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Set up environment variable for cron and run the command on container startup
CMD printenv | awk '{print "export " $1}' > /container_environment.sh && cron && /bin/bash

