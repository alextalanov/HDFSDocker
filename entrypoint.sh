#!/bin/sh

while [[ $1 ]]; do
case $1 in
     --command)
          shift
          COMMAND=$1
          shift
          ;;
     --config)
          shift
          CONFIG=$1
          shift
          ;;
     *)
          echo "'$1' arg is not supported"
          exit 1
          ;;
esac
done

if [[ ! $COMMAND ]]; then
	echo '--command must be passed'
	exit 1
fi

if [[ $CONFIG ]]; then
	easy-start.py "$COMMAND" "$CONFIG"
else
	easy-start.py "$COMMAND"
fi

DIR=$HADOOP_PID_DIR
PID=$(cat $DIR/$(ls $DIR | grep ^.*\.pid$))

sleep 1m
echo "Monitoring for process=$PID ..."
while [ -e /proc/$PID ]; do
    sleep 5m
done
echo "Process $PID has finished"
