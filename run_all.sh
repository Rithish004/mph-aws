#!/bin/bash
set -e
echo "###################################"
echo "#  mph-aws — EC2 Full Setup       #"
echo "#  3 Unix  +  2 Windows Server    #"
echo "###################################"
bash scripts/00_prerequisites.sh
bash scripts/01_create_key_pair.sh
bash scripts/02_create_security_groups.sh
bash scripts/03_launch_unix_instances.sh
bash scripts/04_launch_windows_instances.sh
bash scripts/05_verify_instances.sh
echo "###################################"
echo "#  ALL 5 INSTANCES CREATED!       #"
echo "###################################"
