#!/bin/bash
set +ex

## Hacky way to build inventory file
echo "all: $(cd ../../infra && terraform output db_ip)" > inventory.yml
echo "  hosts: $(cd ../../infra && terraform output ec2_ip)" >> inventory.yml

