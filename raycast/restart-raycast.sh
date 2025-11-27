#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Restart Raycast
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Restart Raycast
# @raycast.author oscmarb

nohup bash -c 'killall Raycast && sleep 1 && open -a Raycast' >/dev/null 2>&1 