#!/bin/bash

TARGET_IP=$1
if [ -z $TARGET_IP ]
then
    echo "FATAL: Missing required parameter TARGET_IP" >&2
    exit 1
fi

echo "INFO: Target IP $TARGET_IP" >&2

for (( i=10; ; i-- ))
do
  PING_MESSAGE=$(ping -c1 -W1 "$TARGET_IP")
  PING_RESULT=$?
  if [ $PING_RESULT -eq 0 ]
  then
    echo "INFO: Connected successfully" >&2
    exit 0
  fi

  if [[ $i -le 0 ]]
  then
    break
  fi
  echo "INFO: Not connected, retries left: $i" >&2
  sleep 1
done
echo "Last ping message:" >&2
echo "$PING_MESSAGE" >&2
echo "FATAL: Connection timeout elapsed" >&2
exit 1
