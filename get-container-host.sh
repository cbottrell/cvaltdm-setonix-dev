#!/bin/bash

# Helper script to get the compute node hostname where the container is running

CONTAINER_HOST_FILE="$MYSOFTWARE/fakeHome/.container_host"

if [ ! -f "$CONTAINER_HOST_FILE" ]; then
    echo "Error: Container host file not found at $CONTAINER_HOST_FILE"
    echo "Make sure the container is running with: bash run-container.sh"
    exit 1
fi

HOST=$(cat "$CONTAINER_HOST_FILE")

if [ -z "$HOST" ]; then
    echo "Error: Container host file is empty"
    exit 1
fi

echo "Container is running on: $HOST"
echo ""
echo "Update your ~/.ssh/config vscode-container entry with:"
echo "    HostName $HOST"
echo ""
echo "Or use SSH directly:"
echo "    ssh -o HostName=$HOST -o ProxyJump=setonix -p 9300 USER_NAME@$HOST"
