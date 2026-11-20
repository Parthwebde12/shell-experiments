#!/bin/bash
# todo.sh - a simple command-line to-do list
# Usage:
#   ./todo.sh add "Buy milk"
#   ./todo.sh list
#   ./todo.sh done <number>
#   ./todo.sh remove <number>
#   ./todo.sh clear

set -euo pipefail

todo_file="${TODO_FILE:-$HOME/.todo_list.txt}"
touch "$todo_file"

usage() {
  echo "Usage: $0 {add \"task\" | list | done <number> | remove <number> | clear}"
  exit 1
}

[ $# -ge 1 ] || usage

command="$1"

case "$command" in
  add)
    [ $# -ge 2 ] || { echo "Please provide a task."; exit 1; }
    echo "[ ] $2" >> "$todo_file"
    echo "Added: $2"
    ;;

  list)
    if [ ! -s "$todo_file" ]; then
      echo "No tasks yet. Add one with: $0 add \"your task\""
    else
      echo "Your tasks:"
      nl -w2 -s'. ' "$todo_file"
    fi
    ;;

  done)
    [ $# -ge 2 ] || { echo "Please provide a task number."; exit 1; }
    num="$2"
    total=$(wc -l < "$todo_file")
    if ! [[ "$num" =~ ^[0-9]+$ ]] || [ "$num" -lt 1 ] || [ "$num" -gt "$total" ]; then
      echo "Invalid task number."
      exit 1
    fi
    sed -i.bak "${num}s/^\[ \]/[x]/" "$todo_file" && rm -f "$todo_file.bak"
    echo "Marked task $num as done."
    ;;

  remove)
    [ $# -ge 2 ] || { echo "Please provide a task number."; exit 1; }
    num="$2"
    total=$(wc -l < "$todo_file")
    if ! [[ "$num" =~ ^[0-9]+$ ]] || [ "$num" -lt 1 ] || [ "$num" -gt "$total" ]; then
      echo "Invalid task number."
      exit 1
    fi
    sed -i.bak "${num}d" "$todo_file" && rm -f "$todo_file.bak"
    echo "Removed task $num."
    ;;

  clear)
    read -p "Delete ALL tasks? (y/n) " answer
    if [ "$answer" = "y" ]; then
      : > "$todo_file"
      echo "All tasks cleared."
    else
      echo "Cancelled."
    fi
    ;;

  *)
    usage
    ;;
esac