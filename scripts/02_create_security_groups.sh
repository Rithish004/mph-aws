#!/bin/bash
set -e
source ./config/variables.sh
echo "===== STEP 2 — Creating Security Groups ====="
mkdir -p outputs

create_sg() {
    local SG_NAME=$1 DESCRIPTION=$2 PORT=$3 OUTPUT_FILE=$4
    EXISTING_ID=$(aws ec2 describe-security-groups \
        --filters "Name=group-name,Values=$SG_NAME" \
        --region "$AWS_REGION" \
        --query "SecurityGroups[0].GroupId" \
        --output text 2>/dev/null)
    if [ "$EXISTING_ID" != "None" ] && [ -n "$EXISTING_ID" ]; then
        echo "[WARN] $SG_NAME already exists: $EXISTING_ID"
        echo "$EXISTING_ID" > "$OUTPUT_FILE"
        return
    fi
    SG_ID=$(aws ec2 create-security-group \
        --group-name "$SG_NAME" \
        --description "$DESCRIPTION" \
        --region "$AWS_REGION" \
        --query "GroupId" --output text)
    aws ec2 authorize-security-group-ingress \
        --group-id "$SG_ID" --protocol tcp \
        --port "$PORT" --cidr 0.0.0.0/0 \
        --region "$AWS_REGION"
    echo "$SG_ID" > "$OUTPUT_FILE"
    echo "[OK] $SG_NAME → $SG_ID (port $PORT)"
}

create_sg "$SG_UNIX_NAME"    "Unix instances - SSH"  22   "outputs/sg_unix_id.txt"
create_sg "$SG_WINDOWS_NAME" "Windows instances - RDP" 3389 "outputs/sg_windows_id.txt"
echo "[DONE] Security groups ready."
