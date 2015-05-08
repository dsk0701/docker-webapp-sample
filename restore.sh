#! /bin/bash -e

CONTAINER_RESTORE_DATA_DIR=/var/lib/postgresql/data
CONTAINER_RESTORE_DIR=/restore
HOST_RESTORE_DIR="$(pwd)/restore"

STORAGE_CONTAINER_NAME=`docker-compose ps | grep storage | awk '{print $1}'`

mkdir -p ${HOST_RESTORE_DIR}

LATEST_RESTORE_FILE=`ls -lt ${HOST_RESTORE_DIR}/backup-* | head -n 1 | awk '{print $9}'`
: ${RESTORE_FILE_NAME:=${LATEST_RESTORE_FILE}}

# レストア用アーカイブを確認します。
if [ -z ${RESTORE_FILE_NAME} ] || [ ! -f ${RESTORE_FILE_NAME} ]; then
    echo "レストア用アーカイブを ${HOST_RESTORE_DIR} 配下に配置してください。"
    exit 1
fi

# コンテナを停止します。
echo "Stopping containers..."
docker-compose stop

# リストア領域をクリアします。
echo "Before"
docker run --rm --volumes-from ${STORAGE_CONTAINER_NAME} ubuntu ls -l ${CONTAINER_RESTORE_DATA_DIR}

docker run --rm --volumes-from ${STORAGE_CONTAINER_NAME} ubuntu rm -rf ${CONTAINER_RESTORE_DATA_DIR}/*

echo "After"
docker run --rm --volumes-from ${STORAGE_CONTAINER_NAME} ubuntu ls -l ${CONTAINER_RESTORE_DATA_DIR}

exit

# リストアを行います。
docker run --rm --volumes-from ${STORAGE_CONTAINER_NAME} -v ${HOST_RESTORE_DIR}:${CONTAINER_RESTORE_DIR} ubuntu tar zxvf ${CONTAINER_RESTORE_DIR}/${RESTORE_FILE_NAME}

#################
docker rm dockerwebappsample_storage_1

docker create -v /var/lib/postgresql/data --name dockerwebappsample_storage_1 dockerwebappsample_storage /bin/bash

docker run --rm --volumes-from dockerwebappsample_storage_1 -v $(pwd)/restore:/restore ubuntu tar zxvf /restore/backup-20150507_0832.tar.gz

