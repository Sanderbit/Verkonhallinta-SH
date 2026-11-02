#!/usr/bin/env bash
set -e

docker exec clab-hamk-verkonhallinta-golden-ansible ansible-playbook -i /ansible/inventory.ini /ansible/playbooks/install-snmp.yml
