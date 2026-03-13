#!/bin/bash
set -e
source ./config/variables.sh
echo "===== STEP 4 — Launching 2 Windows Instances ====="
[ ! -f "outputs/sg_windows_id.txt" ] && echo "[ERROR] Run step 02 first." && exit 1
SG_WIN_ID=$(cat outputs/sg_windows_id.txt)
> outputs/windows_instance_ids.txt

launch_windows() {
    local NAME=$1
    echo "[INFO] Launching $NAME..."
    ID=$(aws ec2 run-instances \
        --image-id "$AMI_WINDOWS" \
        --instance-type "$INSTANCE_TYPE_WINDOWS" \
        --key-name "$KEY_PAIR_NAME" \
        --security-group-ids "$SG_WIN_ID" \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$NAME},{Key=Project,Value=mph-aws},{Key=OS,Value=Windows}]" \
        --region "$AWS_REGION" \
        --query "Instances[0].InstanceId" --output text)
    echo "[OK] $NAME → $ID"
    echo "$NAME=$ID" >> outputs/windows_instance_ids.txt
}

launch_windows "$WINDOWS_INSTANCE_1_NAME"
launch_windows "$WINDOWS_INSTANCE_2_NAME"

echo "[INFO] Waiting for instances to be running (may take 2-3 min)..."
while IFS='=' read -r NAME ID; do
    aws ec2 wait instance-running --instance-ids "$ID" --region "$AWS_REGION"
    echo "[OK] $NAME is RUNNING"
done < outputs/windows_instance_ids.txt
echo "[DONE] All 2 Windows instances launched."
