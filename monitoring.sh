#!/bin/bash

SERVERS=(
"udl-prd-ms2@192.168.100.32"
"udl-prd-ms2@192.168.100.26"
"udl-prd-ms1@192.168.100.28"
)

SSH_KEY="/var/lib/jenkins/.ssh/id_ed25519"

for SERVER in "${SERVERS[@]}"
do
  echo "=============================="
  echo "Processing $SERVER..."

  USER=$(echo $SERVER | cut -d'@' -f1)

  # 🔹 Create folder
  ssh -i $SSH_KEY -o StrictHostKeyChecking=no $SERVER "mkdir -p /home/$USER/raju"

  if [ $? -eq 0 ]; then
    echo "✅ Folder created on $SERVER"
  else
    echo "❌ Failed to create folder on $SERVER"
    continue
  fi

  # 🔹 Verify folder exists
  ssh -i $SSH_KEY -o StrictHostKeyChecking=no $SERVER "ls -ld /home/$USER/raju" >/dev/null 2>&1

  if [ $? -eq 0 ]; then
    echo "✅ Verified folder exists on $SERVER"
  else
    echo "❌ Folder not found on $SERVER"
    continue
  fi

  # 🔹 Delete folder
  ssh -i $SSH_KEY -o StrictHostKeyChecking=no $SERVER "rm -rf /home/$USER/raju"

  if [ $? -eq 0 ]; then
    echo "🗑️ Folder deleted on $SERVER"
  else
    echo "❌ Failed to delete folder on $SERVER"
    continue
  fi

  # 🔹 Final verification
  ssh -i $SSH_KEY -o StrictHostKeyChecking=no $SERVER "ls /home/$USER/raju" >/dev/null 2>&1

  if [ $? -ne 0 ]; then
    echo "✅ Folder successfully deleted on $SERVER"
  else
    echo "❌ Folder still exists on $SERVER"
  fi

done

echo "=============================="
echo "🎯 Script execution completed"
