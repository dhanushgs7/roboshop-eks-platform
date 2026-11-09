#!/usr/bin/env bash

set -euo pipefail

AWS_REGION="us-east-1"
AWS_PARAMETER="/roboshop/dev/frontend_target_group_arn"
MANIFEST="kubernetes/tgb.yaml"

if ! command -v aws >/dev/null 2>&1; then
  echo "ERROR: AWS CLI is required."
  exit 1
fi

if ! command -v kubectl >/dev/null 2>&1; then
  echo "ERROR: kubectl is required."
  exit 1
fi

if ! command -v envsubst >/dev/null 2>&1; then
  echo "ERROR: envsubst is required."
  exit 1
fi

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

echo "TargetGroupBinding manifest submitted."