#!/bin/bash
# sysinfo.sh - print a quick summary of the system
# Usage: ./sysinfo.sh

set -u

echo "=============================="
echo "   System Report"
echo "=============================="
echo "Date:      $(date '+%Y-%m-%d %H:%M:%S')"
echo "Hostname:  $(hostname)"
echo "User:      $(whoami)"
echo "OS:        $(uname -s) $(uname -r)"
echo "Uptime:    $(uptime -p 2>/dev/null || uptime)"
echo

echo "--- Disk usage (root) ---"
df -h / | awk 'NR==2 {print "Used: " $3 " of " $2 " (" $5 ")"}'
echo

echo "--- Memory ---"
if command -v free >/dev/null 2>&1; then
  free -h | awk 'NR==2 {print "Used: " $3 " of " $2}'
else
  echo "'free' command not available on this system."
fi
echo

echo "--- Top 5 processes by memory ---"
ps aux --sort=-%mem 2>/dev/null | awk 'NR>1 && NR<=6 {print $4 "%  " $11}' \
  || echo "Not supported on this system."
echo

echo "--- Current folder ---"
echo "Path:   $(pwd)"
echo "Files:  $(find . -maxdepth 1 -type f | wc -l)"
echo "Folders: $(find . -maxdepth 1 -type d ! -name . | wc -l)"