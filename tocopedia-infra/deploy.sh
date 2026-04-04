#!/bin/bash
set -e

cd "$(dirname "$0")"

# ── Load AWS credentials ──────────────────────────────────────────────────────
if [ -f .env ]; then
  source .env
  echo "✓ Loaded credentials from .env"
else
  echo "✗ .env not found. Copy .env.example and fill in your credentials."
  exit 1
fi

# ── Init ──────────────────────────────────────────────────────────────────────
echo ""
echo "==> terraform init"
terraform init -upgrade

# ── Validate ──────────────────────────────────────────────────────────────────
echo ""
echo "==> terraform validate"
terraform validate

# ── Plan ──────────────────────────────────────────────────────────────────────
echo ""
echo "==> terraform plan"
terraform plan -out=tfplan

# ── Confirm ───────────────────────────────────────────────────────────────────
echo ""
read -p "Apply the plan? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
  echo "Aborted."
  rm -f tfplan
  exit 0
fi

# ── Apply ─────────────────────────────────────────────────────────────────────
echo ""
echo "==> terraform apply"
terraform apply tfplan
rm -f tfplan

# ── Output ────────────────────────────────────────────────────────────────────
echo ""
echo "==> Results"
terraform output

echo ""
echo "✓ Done."
echo ""
echo "Next steps:"
echo "  1. Update GitHub secret EC2_HOST with the new public IP"
echo "  2. Push to main to trigger the CI deploy"
