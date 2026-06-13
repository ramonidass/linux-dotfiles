#!/bin/bash

# Determine the URL
if [ -n "$1" ]; then
    # If user provided a link as an argument, use it
    URL="$1"
else
    # If no argument, try to get the git remote origin URL
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        REMOTE=$(git config --get remote.origin.url)

        # Convert SSH format (git@github.com:...) to HTTPS format
        # This handles both Azure and GitHub formats
        URL=$(echo "$REMOTE" | sed -e 's/:/\//g' -e 's/git@/https:\/\//' -e 's/\.git$//')

        echo "Opening repo: $URL"
    else
        echo "Error: Not a git repository and no URL provided."
        exit 1
    fi
fi

# Open in Default Browser (Cross-Platform logic)
case "$OSTYPE" in
  darwin*)  open "$URL" ;;                      # macOS
  linux*)   xdg-open "$URL" ;;                  # Linux
  msys*)    start "$URL" ;;                     # Windows (Git Bash)
  cygwin*)  cmd /c start "$URL" ;;              # Cygwin
  *)        echo "Unknown OS. URL: $URL" ;;
esac
