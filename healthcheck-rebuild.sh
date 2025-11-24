#!/usr/bin/env bash

# N8N_HOST=
# TG_TOKEN=

export PATH=$PATH:/usr/bin

notify() {
    curl -X POST \
        -H "Content-Type: application/json" \
        -d '{"chat_id": "604387802", "text": "n8n rebuilding https://huggingface.co/spaces/tenfyzhong/n8n-free/settings", "disable_notification": false}' \
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
    exit 0
fi

# Parse the JSON response and check the status field
response_status=$(echo "$http_body" | jq -r '.status')

if [ "$response_status" != "ok" ]; then
    echo "::error::Health check failed. Expected status 'ok', but got '$response_status'"
    echo "Response body: $http_body"
    rebuild
    exit 0
fi

echo "Health check successful!"
