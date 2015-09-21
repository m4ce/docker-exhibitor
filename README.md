# Docker image for Exhibitor + Zookeeper
This docker image allows to run a single instance of Exhibitor (1.5.5) + Zookeeper (3.4.6) with support for the following config backends:

* file (e.g. NFS)
* AWS s3
* ZooKeeper

See the usage section for more details.

## Usage
Generic configuration can be driven by exporting the following enviroment variables:

| Environment variable  | Description |
| ------------- | ------------- |
| ZOOKEEPER_DATA_DIR | The local path to store ZooKeeper data (default: /var/lib/zookeeper/snapshots)|
| ZOOKEEPER_LOG_DIR  | The local path to store indexed ZooKeeper transaction logs (default: /var/lib/zookeeper/transactions) |
| ZOOKEEPER_CLUSTER_SIZE | If non-zero, automatic instance management will attempt to keep the ensemble at this fixed size. (default: 0) |
| EXHIBITOR_UI_PORT  | Port for the HTTP Server (default: 8081) |
| EXHIBITOR_HOSTNAME  | Hostname to use for this JVM (default: `hostname`) |

If you wish to use a filesystem to store Exhibitor properties:

| Environment variable  | Description |
| ------------- | ------------- |
| EXHIBITOR_FSCONFIGDIR  | Directory to store Exhibitor properties. Exhibitor uses file system locks so you can specify a shared location so as to enable complete ensemble management. |

This is if you wish to use AWS S3 backend:

| Environment variable  | Description |
| ------------- | ------------- |
| AWS_ACCESS_KEY_ID | AWS access key id |
| AWS_SECRET_ACCESS_KEY | AWS access secret key |
| AWS_S3_BUCKET | The bucket name and key to store the config |
| AWS_S3_PREFIX | When using AWS S3 shared config files, the prefix to use for values such as locks |
| AWS_S3_BACKUP | If true, enables AWS S3 backup of ZooKeeper log files (default: false) |
| AWS_REGION | Region for S3 calls |

If you wish to use ZooKeeper:

| Environment variable  | Description |
| ------------- | ------------- |
| ZK_CONFIG_CONNECT | The initial connection string for ZooKeeper shared config storage |
| ZK_CONFIG_ZPATH | The base ZPath that Exhibitor should use |

## Contact
Matteo Cerutti - matteo.cerutti@hotmail.co.uk
