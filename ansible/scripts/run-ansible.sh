#!/bin/bash
set +ex

rm inventory.yml
rm simpletodo.service

## Hacky way to build inventory file
echo "all: " > inventory.yml
echo "  hosts: " >> inventory.yml
echo "    web: " >> inventory.yml
echo "      ansible_host: $(cd ../../infra && terraform output ec2_ip)" >> inventory.yml
echo "      ansible_user: root" >> inventory.yml


echo "[Unit]" >> simpletodo.service
echo "Description=ToDoApp" >> simpletodo.service
echo "Requires=network-online.target" >> simpletodo.service
echo "Requires=network-online.target" >> simpletodo.service
echo "" >> simpletodo.service
echo "[Service]" >> simpletodo.service
echo "Environment=DB_URL=mongo://$(cd ../../infra && terraform output db_ip | sed -e 's/^"//' -e 's/"$//'):27017" >> simpletodo.service
echo "Environment=SESSION_SECRET=$(cat ~/.aws/credentials  |grep session | awk -F '=' '{print $2}')" >> simpletodo.service
echo "WorkingDirectory=/root/package" >> simpletodo.service
echo "Type=simple" >> simpletodo.service
echo "ExecStart= npm run start" >> simpletodo.service
echo "Restart=on-failure" >> simpletodo.service
echo "" >> simpletodo.service
echo "" >> simpletodo.service
echo "[Install]" >> simpletodo.service
echo "WantedBy=multi-user.target" >> simpletodo.service

cd ../ && ansible-playbook  playbook.yml -i scripts/inventory.yml 
