#!/bin/bash
source ./config/variables.sh
echo "===== CLEANUP — Destroy All Resources ====="
read -p "Type 'yes' to confirm DELETE of all instances: " CONFIRM
[ "$CONFIRM" != "yes" ] && echo "Aborted." && exit 0

while IFS='=' read -r NAME ID; do
    aws ec2 terminate-instances --instance-ids "$ID" --region "$AWS_REGION" > /dev/null
    echo "[OK] Terminated: $NAME ($ID)"
done < outputs/unix_instance_ids.txt

while IFS='=' read -r NAME ID; do
    aws ec2 terminate-instances --instance-ids "$ID" --region "$AWS_REGION" > /dev/null
    echo "[OK] Terminated: $NAME ($ID)"
done < outputs/windows_instance_ids.txt

echo "[INFO] Waiting for termination..."
ALL_IDS="$(cut -d= -f2 outputs/unix_instance_ids.txt | tr '\n' ' ') $(cut -d= -f2 outputs/windows_instance_ids.txt | tr '\n' ' ')"
aws ec2 wait instance-terminated --instance-ids $ALL_IDS --region "$AWS_REGION"

aws ec2 delete-security-group --group-id $(cat outputs/sg_unix_id.txt) --region "$AWS_REGION" && echo "[OK] Unix SG deleted"
aws ec2 delete-security-group --group-id $(cat outputs/sg_windows_id.txt) --region "$AWS_REGION" && echo "[OK] Windows SG deleted"
aws ec2 delete-key-pair --key-name "$KEY_PAIR_NAME" --region "$AWS_REGION" && echo "[OK] Key pair deleted"
rm -f "$KEY_FILE" outputs/*.txt
echo "[DONE] Everything destroyed."
