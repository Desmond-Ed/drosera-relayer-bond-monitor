#!/bin/bash
set -e

echo "=== Publishing Drosera Relayer Bond Monitor ==="

# 1. Install GitHub CLI if needed
if ! command -v gh &> /dev/null; then
    echo "Installing GitHub CLI..."
    apt update && apt install curl -y
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list
    apt update && apt install gh -y
fi

# 2. Authenticate
if ! gh auth status &>/dev/null; then
    echo "Please authenticate with GitHub CLI..."
    gh auth login
fi

# 3. Prepare repository
cd ~/relayer-bond-monitor
[ ! -d ".git" ] && git init && git branch -M main
git add . 2>/dev/null || true
git commit -m "Deploy: Drosera Relayer Bond Monitor" --allow-empty

# 4. Create and push
gh repo create drosera-relayer-bond-monitor \
  --public \
  --description "Drosera Security Trap: Relayer Bond Monitor" \
  --source=. \
  --remote=origin \
  --push

echo ""
echo "✅ Repository published successfully!"
echo "📁 https://github.com/$(gh api user | jq -r .login)/drosera-relayer-bond-monitor"
