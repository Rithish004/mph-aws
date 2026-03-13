#!/bin/bash
set -e
source ./config/variables.sh
echo "===== STEP 1 — Creating Key Pair ====="
mkdir -p outputs
EXISTING=$(aws ec2 describe-key-pairs \
    --key-names "$KEY_PAIR_NAME" \
    --region "$AWS_REGION" \
    --query "KeyPairs[0].KeyName" \
    --output text 2>/dev/null || echo "None")
if [ "$EXISTING" == "$KEY_PAIR_NAME" ]; then
    echo "[WARN] Key pair already exists, skipping."
else
    aws ec2 create-key-pair \
        --key-name "$KEY_PAIR_NAME" \
        --query "KeyMaterial" \
        --output text \
        --region "$AWS_REGION" > "$KEY_FILE"
    chmod 400 "$KEY_FILE"
    echo "[OK] Key saved to $KEY_FILE"
fi
echo "[DONE] Key pair step complete."
