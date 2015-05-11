#! /bin/bash -e

CONTAINER_RESTORE_DATA_DIR=/var/lib/postgresql/data
CONTAINER_RESTORE_DIR=/restore
HOST_RESTORE_DIR="$(pwd)/restore"

STORAGE_SERVICE_NAME="storage"
STORAGE_CONTAINER_NAME=`docker-compose ps | grep ${STORAGE_SERVICE_NAME} | awk '{print $1}'`

mkdir -p ${HOST_RESTORE_DIR}

LATEST_RESTORE_FILE=`ls -lt ${HOST_RESTORE_DIR}/backup-* | head -n 1 | awk '{print $9}' | xargs basename`
: ${RESTORE_FILE_NAME:=${LATEST_RESTORE_FILE}}
echo RESTORE_FILE_NAME:${RESTORE_FILE_NAME}

# レストア用アーカイブを確認します。
if [ -z ${RESTORE_FILE_NAME} ] || [ ! -f ${HOST_RESTORE_DIR}/${RESTORE_FILE_NAME} ]; then
    echo "レストア用アーカイブを ${HOST_RESTORE_DIR} 配下に配置してください。"
    exit 1
fi

# コンテナを停止します。
echo "Stopping containers..."
docker-compose stop

# データコンテナを削除します。
echo "Removing data container..."
docker-compose rm --force ${STORAGE_SERVICE_NAME}

# データコンテナの新規作成と実行します。
echo "Starting a new data container..."
docker-compose up -d ${STORAGE_SERVICE_NAME}

# リストアを行います。
echo "Restoring data..."
docker run --rm --volumes-from ${STORAGE_CONTAINER_NAME} -v ${HOST_RESTORE_DIR}:${CONTAINER_RESTORE_DIR} ubuntu tar zxvf ${CONTAINER_RESTORE_DIR}/${RESTORE_FILE_NAME}

# 他のコンテナをすべて起動します。
echo "Starting other containers..."
docker-compose up --no-recreate -d

