#!/bin/bash
# Deploy infurno-nonsense to Netlify
# Usage: ./deploy.sh "optional deploy message"
#
# Uses the Netlify CLI with --no-build to skip build steps
# (we're deploying a single static HTML file)

set -e

SITE_ID="a94ab0e3-858b-4b95-a2b0-9cae505d1a3d"
TOKEN="nfp_1NUxfhdrxWJumAckC5HfySH281bjGm5v2e8c"
MSG="${1:-Manual deploy via deploy.sh}"

cd ~/infurno

echo "Deploying to infurno-nonsense..."
echo "Message: $MSG"

netlify deploy \
  --site "$SITE_ID" \
  --auth "$TOKEN" \
  --no-build \
  --prod \
  -m "$MSG"

echo ""
echo "Live URL: https://nonsense.pigpup.farm"
