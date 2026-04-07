#!/bin/bash

BOT_TOKEN="8290404599:AAFOcGBJhoFKf6lsV6yCDjxDFVOPgo7JV1U"
CHAT_ID="1439747381"

SERVERS=("192.168.100.32" "192.168.100.26" "192.168.100.28")

THRESHOLD_CPU=80
THRESHOLD_MEM=80

for SERVER in "${SERVERS[@]}"
do
  echo "Checking $SERVER..."

  CPU=$(ssh ubuntu@$SERVER "top -bn1 | grep 'Cpu' | awk '{print 100 - \$8}' | cut -d. -f1")
  MEM=$(ssh ubuntu@$SERVER "free | grep Mem | awk '{print \$3/\$2 * 100.0}' | cut -d. -f1")

  if [ "$CPU" -gt "$THRESHOLD_CPU" ] || [ "$MEM" -gt "$THRESHOLD_MEM" ]; then
    MESSAGE="⚠️ Alert: $SERVER CPU=$CPU% MEM=$MEM%"
    
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
    -d chat_id=$CHAT_ID \
    -d text="$MESSAGE"
  else
    echo "$SERVER is healthy"
  fi
done
