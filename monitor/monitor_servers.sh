#!/bin/bash

BOT_TOKEN="8290404599:AAFOcGBJhoFKf6lsV6yCDj"
CHAT_ID="143974"

SERVERS=(
"udl-prd-ms2@192.168.100.32"
"udl-prd-ms2@192.168.100.26"
"udl-prd-ms1@192.168.100.28"
)

THRESHOLD_CPU=80
THRESHOLD_MEM=80

for SERVER in "${SERVERS[@]}"
do
  echo "Checking $SERVER..."

  CPU=$(ssh -i /home/udl-prd-ms2/.ssh/id_ed25519 -o StrictHostKeyChecking=no $SERVER "top -bn1 | grep 'Cpu' | awk '{print 100 - \$8}' | cut -d. -f1" 2>/dev/null)
  MEM=$(ssh -i /home/udl-prd-ms2/.ssh/id_ed25519 -o StrictHostKeyChecking=no $SERVER "free | grep Mem | awk '{print \$3/\$2 * 100.0}' | cut -d. -f1" 2>/dev/null)
  # 🔹 Handle empty values (important fix)
  if [[ -z "$CPU" || -z "$MEM" ]]; then
    echo "❌ Unable to fetch data from $SERVER"
    continue
  fi

  echo "CPU: $CPU% | MEM: $MEM%"

  if [ "$CPU" -gt "$THRESHOLD_CPU" ] || [ "$MEM" -gt "$THRESHOLD_MEM" ]; then
    MESSAGE="⚠️ Alert: $SERVER CPU=$CPU% MEM=$MEM%"
    
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
    -d chat_id=$CHAT_ID \
    -d text="$MESSAGE"
  else
    echo "✅ $SERVER is healthy"
  fi
done
