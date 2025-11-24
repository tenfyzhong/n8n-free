#!/usr/bin/env bash

# HF_REPO=tenfyzhong/n8n-free
# N8N_HOST=tenfyzhong-n8n-free.hf.space
# TG_TOKEN=
# TG_CHAT_ID=

for cmd in git curl jq; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "::error::This script requires '$cmd' but it's not installed. Aborting." >&2
        exit 1
    fi
done

export PATH=$PATH:/usr/bin

if [ -z "$HF_REPO" ]; then
    exit 1
fi

if [ -z "$N8N_HOST" ]; then
    exit 1
fi

notify() {
    if [ -z "$TG_TOKEN" ]; then
        exit 0
    fi
    curl -X POST \
        -H "Content-Type: application/json" \
        -d "{\"chat_id\": \"$TG_CHAT_ID\", \"text\": \"n8n rebuilding https://huggingface.co/spaces/$HF_REPO/settings\", \"disable_notification\": false}" \
        "https://api.telegram.org/bot$TG_TOKEN/sendMessage"

}

rebuild() {
    git reset --hard HEAD
    git pull --force
    date >rebuild.txt
    git add rebuild.txt
    git commit -m "rebuild"
    git push
    notify
}

# Make the request and capture the body and status code in variables
http_response=$(curl -s -w "\n%{http_code}" "https://$N8N_HOST/healthz/readiness")
http_body=$(echo "$http_response" | sed '$d')
http_status=$(echo "$http_response" | tail -n1)

echo "http_body: $http_body"
echo "http_status: $http_status"

# Check the HTTP status code
if [ "$http_status" -ne 200 ]; then
    echo "::error::Health check failed with status code $http_status"
    echo "Response body: $http_body"
    rebuild
    exit 1
fi

# Parse the JSON response and check the status field
response_status=$(echo "$http_body" | jq -r '.status')

if [ "$response_status" != "ok" ]; then
    echo "::error::Health check failed. Expected status 'ok', but got '$response_status'"
    echo "Response body: $http_body"
    rebuild
    exit 1
fi

echo "Health check successful!"
