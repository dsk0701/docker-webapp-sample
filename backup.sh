#! /bin/bash -e

BACKUP_SRC_DIR=/var/lib/postgresql/data
BACKUP_FILE_NAME=`date +"%Y%m%d_%I%M"`
HOST_BACKUP_DIR=`pwd`
CONTAINER_BACKUP_DIR=/backup

SONAR_CONTAINER_ID=`docker ps | grep sonar | awk '{print $1}'`
STORAGE_CONTAINER_ID=`docker ps | grep storage | awk '{print $1}'`

echo "stopping container id:${SONAR_CONTAINER_ID}"
docker stop ${SONAR_CONTAINER_ID}

docker run --rm --volumes-from ${STORAGE_CONTAINER_ID} -v ${HOST_BACKUP_DIR}:${CONTAINER_BACKUP_DIR} ubuntu tar zcvf ${CONTAINER_BACKUP_DIR}/${BACKUP_FILE_NAME}.tar.gz ${BACKUP_SRC_DIR}

while [ `docker ps | wc -l` != 1 ]
do
    echo "wait until all container have stopped."
    sleep 5
done

docker-compose up --no-recreate

