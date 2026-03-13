#!/bin/bash
source ./config/variables.sh
echo "===== STEP 5 — Verifying All 5 Instances ====="
aws ec2 describe-instances \
    --region "$AWS_REGION" \
    --filters "Name=tag:Project,Values=mph-aws" \
              "Name=instance-state-name,Values=pending,running" \
    --query "Reservations[*].Instances[*].{Name:Tags[?Key=='Name']|[0].Value,ID:InstanceId,State:State.Name,Type:InstanceType,IP:PublicIpAddress,OS:Tags[?Key=='OS']|[0].Value}" \
    --output table

echo ""
echo "--- SSH Commands (Unix) ---"
while IFS='=' read -r NAME ID; do
    IP=$(aws ec2 describe-instances --instance-ids "$ID" --region "$AWS_REGION" \
        --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
    [[ "$NAME" == *"amazon"* ]] && USER="ec2-user" || USER="ubuntu"
    echo "  $NAME → ssh -i $KEY_FILE $USER@$IP"
done < outputs/unix_instance_ids.txt

echo ""
echo "--- RDP Info (Windows) ---"
while IFS='=' read -r NAME ID; do
    IP=$(aws ec2 describe-instances --instance-ids "$ID" --region "$AWS_REGION" \
        --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
    echo "  $NAME → RDP: $IP:3389 | User: Administrator"
    echo "  Password: aws ec2 get-password-data --instance-id $ID --priv-launch-key $KEY_FILE --region $AWS_REGION"
done < outputs/windows_instance_ids.txt
echo "[DONE] Verification complete."
