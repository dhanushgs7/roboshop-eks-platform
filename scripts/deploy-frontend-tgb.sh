#!/usr/bin/env bash

set -euo pipefail

AWS_REGION="us-east-1"
AWS_PARAMETER="/roboshop/dev/frontend_target_group_arn"
MANIFEST="kubernetes/tgb.yaml"

for command in aws kubectl envsubst; do
  if ! command -v "$command" >/dev/null 2>&1; then
    echo "ERROR: Required command not found: $command"
    exit 1
  fi
done

if [[ ! -f "$MANIFEST" ]]; then
  echo "ERROR: TargetGroupBinding template not found: $MANIFEST"
  exit 1
fi

FRONTEND_TARGET_GROUP_ARN=$(
  aws ssm get-parameter \
    --region "$AWS_REGION" \
    --name "$AWS_PARAMETER" \
    --query 'Parameter.Value' \
    --output text
)

if [[ -z "$FRONTEND_TARGET_GROUP_ARN" || "$FRONTEND_TARGET_GROUP_ARN" == "None" ]]; then
  echo "ERROR: Frontend target group ARN not found in SSM."
  exit 1
fi

export FRONTEND_TARGET_GROUP_ARN

echo "Applying frontend TargetGroupBinding..."
envsubst '${FRONTEND_TARGET_GROUP_ARN}' < "$MANIFEST" | kubectl apply -f -

echo "TargetGroupBinding submitted."
