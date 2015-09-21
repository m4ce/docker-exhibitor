#!/bin/bash
#
# run.sh
#
# Author: Matteo Cerutti <matteo.cerutti@swisscom.com>
#

# print environment for debugging
env

# zookeeper defaults
ZOOKEEPER_DATA_DIR=${ZOOKEEPER_DATA_DIR:-/var/lib/zookeeper/snapshots}
ZOOKEEPER_LOG_DIR=${ZOOKEEPER_LOG_DIR:-/var/lib/zookeeper/transactions}
ZOOKEEPER_CLUSTER_SIZE=${ZOOKEEPER_CLUSTER_SIZE:-0}

# prepare config file
cp /opt/exhibitor/defaults.conf.template /opt/exhibitor/defaults.conf
sed -i "s;@ZOOKEEPER_DATA_DIR@;$ZOOKEEPER_DATA_DIR;g" /opt/exhibitor/defaults.conf
sed -i "s;@ZOOKEEPER_LOG_DIR@;$ZOOKEEPER_LOG_DIR;g" /opt/exhibitor/defaults.conf
sed -i "s;@ZOOKEEPER_CLUSTER_SIZE@;$ZOOKEEPER_CLUSTER_SIZE;g" /opt/exhibitor/defaults.conf

# exhibitor defaults
EXHIBITOR_UI_PORT=${EXHIBITOR_UI_PORT:-8081}
EXHIBITOR_HOSTNAME=${EXHIBITOR_HOSTNAME:-$(hostname)}
if [ -n "$EXHIBITOR_FSCONFIGDIR" ]; then
  EXHIBITOR_OPTS="$EXHIBITOR_OPTS --configtype file --fsconfigdir $EXHIBITOR_FSCONFIGDIR"
elif [[ -n "$AWS_ACCESS_KEY_ID" && -n "$AWS_SECRET_ACCESS_KEY" && -n "$AWS_S3_BUCKET" && -n "$AWS_S3_PREFIX" && -n "$AWS_REGION" ]]; then
  cat > /opt/exhibitor/credentials.conf <<EOF
com.netflix.exhibitor.s3.access-key-id=$AWS_ACCESS_KEY_ID
com.netflix.exhibitor.s3.access-secret-key=$AWS_SECRET_ACCESS_KEY
EOF

  # defaults for aws s3
  AWS_S3_BACKUP=${AWS_S3_BACKUP:-false}

  EXHIBITOR_OPTS="$EXHIBITOR_OPTS --configtype s3 --s3config \"$AWS_S3_BUCKET:$AWS_S3_PREFIX\" --s3credentials /opt/exhibitor/credentials.conf --s3region $AWS_REGION --s3backup $AWS_S3_BACKUP"
elif [[ -n "$ZK_CONFIG_CONNECT" && -n "$ZK_CONFIG_ZPATH" ]]; then
  EXHIBITOR_OPTS="$EXHIBITOR_OPTS --configtype zookeeper --zkconfigconnect "$ZK_CONFIG_CONNECT" --zkconfigzpath \"$ZK_CONFIG_ZPATH\""
else
  echo "You must choose which config shared storage to use (file, s3, zookeeper)" >&2
  exit 1
fi

# prepare directories
mkdir -p $ZOOKEEPER_DATA_DIR $ZOOKEEPER_LOG_DIR

echo "Starting ZooKeeper [EXHIBITOR_OPTS: $EXHIBITOR_OPTS]"
java -jar exhibitor.jar --port $EXHIBITOR_UI_PORT --defaultconfig /opt/exhibitor/defaults.conf --hostname $EXHIBITOR_HOSTNAME $EXHIBITOR_OPTS
