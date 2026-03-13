#!/bin/bash
set -e
source ./config/variables.sh
echo "===== STEP 3 — Launching 3 Unix Instances ====="
[ ! -f "outputs/sg_unix_id.txt" ] && echo "[ERROR] Run step 02 first." && exit 1
SG_UNIX_ID=$(cat outputs/sg_unix_id.txt)
> outputs/unix_instance_ids.txt

launch_unix() {
    local NAME=$1 AMI=$2
    echo "[INFO] Launching $NAME..."
    ID=$(aws ec2 run-instances \
        --image-id "$AMI" \
        --instance-type "$INSTANCE_TYPE_UNIX" \
        --key-name "$KEY_PAIR_NAME" \
        --security-group-ids "$SG_UNIX_ID" \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$NAME},{Key=Project,Value=mph-aws},{Key=OS,Value=Unix}]" \
        --region "$AWS_REGION" \
        --query "Instances[0].InstanceId" --output text)
    echo "[OK] $NAME → $ID"
    echo "$NAME=$ID" >> outputs/unix_instance_ids.txt
}

launch_unix "$UNIX_INSTANCE_1_NAME" "$AMI_AMAZON_LINUX"
launch_unix "$UNIX_INSTANCE_2_NAME" "$AMI_UBUNTU"
launch_unix "$UNIX_INSTANCE_3_NAME" "$AMI_UBUNTU"

echo "[INFO] Waiting for instances to be running..."
while IFS='=' read -r NAME ID; do
    aws ec2 wait instance-running --instance-ids "$ID" --region "$AWS_REGION"
    echo "[OK] $NAME is RUNNING"
done < outputs/unix_instance_ids.txt
echo "[DONE] All 3 Unix instances launched."
