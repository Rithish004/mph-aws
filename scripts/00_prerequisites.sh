#!/bin/bash
set -e
source ./config/variables.sh
echo "===== STEP 0 — Checking Prerequisites ====="
if ! command -v aws &> /dev/null; then
    echo "[ERROR] AWS CLI not found."
    exit 1
else
    echo "[OK] AWS CLI: $(aws --version)"
fi
IDENTITY=$(aws sts get-caller-identity --region "$AWS_REGION")
if [ $? -ne 0 ]; then
    echo "[ERROR] Invalid AWS credentials."
    exit 1
fi
echo "[OK] Account: $(echo $IDENTITY | grep -o '"Account": "[^"]*"' | cut -d'"' -f4)"
echo "[OK] Region : $AWS_REGION"
mkdir -p outputs
echo "[DONE] Prerequisites passed."
