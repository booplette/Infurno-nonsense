#!/bin/bash
# Deploy infurno-nonsense to Netlify
# Usage: ./deploy.sh "optional deploy message"
#
# After GitHub integration is set up, you can just do:
#   git push origin main
# And Netlify will auto-deploy.

set -e

MSG="${1:-Manual deploy via deploy.sh}"

echo "Deploying to Netlify..."
echo "Message: $MSG"

cd ~/infurno

# Deploy using Netlify CLI
NETLIFY_AUTH_TOKEN="nfp_1NUxfhdrxWJumAckC5HfySH281bjGm5v2e8c" netlify deploy \
  --no-build \
  --prod \
  -m "$MSG" \
  --auth "nfp_1NUxfhdrxWJumAckC5HfySH281bjGm5v2e8c"

echo ""
echo "✅ Deploy complete!"
echo "Live URL: https://nonsense.pigpup.farm"
