#! /bin/bash -e

CONTAINER_BACKUP_SRC_DIR=/var/lib/postgresql/data
CONTAINER_BACKUP_DST_DIR=/backup
BACKUP_FILE_NAME=`date +"%Y%m%d_%I%M"`
HOST_BACKUP_DIR=`pwd`

# SONAR_CONTAINER_ID=`docker ps | grep sonar | awk '{print $1}'`
STORAGE_CONTAINER_ID=`docker ps | grep storage | awk '{print $1}'`

# コンテナを停止します。
echo "Stopping containers..."
docker-compose stop

# バックアップを行います。
docker run --rm --volumes-from ${STORAGE_CONTAINER_ID} -v ${HOST_BACKUP_DIR}:${CONTAINER_BACKUP_DST_DIR} ubuntu tar zcvf ${CONTAINER_BACKUP_DST_DIR}/backup-${BACKUP_FILE_NAME}.tar.gz ${CONTAINER_BACKUP_SRC_DIR}

# 4世代残しておく。
COUNT=0
ls -1t ${HOST_BACKUP_DIR}/backup-* | while read LINE
do
    if [ $COUNT -gt 3 ]; then
        echo "Remove unnecessary backup file."
        rm -f ${LINE}
    fi
    COUNT=$(expr $COUNT + 1)
done

# コンテナを再開します。
docker-compose up --no-recreate -d

