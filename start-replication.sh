# This is the startup script for primary mongodb NODE_PREFIX

REPLICAS_NUMBER=$1
REPLICASET_NAME=$2
NODE_PREFIX=$3
echo "========================================"
echo "REPLICAS_NUMBER = $REPLICAS_NUMBER"
echo "REPLICASET_NAME = $REPLICASET_NAME"
echo "NODE_PREFIX     = $NODE_PREFIX"
echo "========================================"

for replica in `seq 1 ${REPLICAS_NUMBER}`;do
  mongo --host ${NODE_PREFIX}-$replica --eval 'db'
  if [ $? -ne 0 ]; then
    exit 1
  fi
done

# Connect to rs1 and configure replica set if not done
echo "Getting Status"
status=$(mongo --host ${NODE_PREFIX}-1 --quiet --eval 'rs.status().members.length')
if [ $? -ne 0 ]; then
  # Replicaset not yet configured
  mongo --host ${NODE_PREFIX}-1 --eval  "rs.initiate({ _id: \"${REPLICASET_NAME}\", version: 1, members: [ $(for i in $(seq 1 ${REPLICAS_NUMBER}); do echo -n "{ _id: $(($i-1)), host : \"${NODE_PREFIX}-$i\" },"; done)  ] })";
fi
