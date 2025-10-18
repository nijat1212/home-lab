#!/bin/bash

LOG_DIR="$HOME/maintenance_logs"
LOG_FILE="$LOG_DIR/$(date +%Y-%m-%d_%H-%M-%S).log"

mkdir -p "$LOG_DIR"

{
  echo "=== Server Maintenance Log ==="
  echo "Date: $(date)"
  echo ""

  echo "Updating system ..."
  sudo apt update &&  sudo apt upgrade -y
  echo ""

  echo "Disk usage:"
  df -h
  echo ""

  echo "Memory usage:"
  free -h
  echo ""

  echo "Uptime:"
  uptime
} >> "$LOG_FILE" 2>&1

echo "Maintenance complate. Log saved to: $LOG_FILE"

