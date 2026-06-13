#!/bin/bash

GITIGNORE_TEMPLATE_PATH="$HOME/git_template/.gitignore_template"

INITIAL_COMMIT_MESSAGE="feat: init"

# --- Helper Function for Error Handling ---
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

[ -f "$GITIGNORE_TEMPLATE_PATH" ] || error_exit ".gitignore template not found at $GITIGNORE_TEMPLATE_PATH"

TARGET_DIR="."

if [ -n "$1" ]; then # If an argument is provided (not empty)
    PROJECT_NAME="$1"
    TARGET_DIR="./$PROJECT_NAME"

    if [ -d "$TARGET_DIR" ]; then
        error_exit "Directory '$TARGET_DIR' already exists. Aborting to prevent overwriting."
    fi

    echo "Creating new project directory: $TARGET_DIR"
    mkdir -p "$TARGET_DIR" || error_exit "Failed to create directory $TARGET_DIR"
fi

cd "$TARGET_DIR" || error_exit "Failed to change to directory $TARGET_DIR"

echo "Initializing Git repository in: $(pwd)"

if [ -d ".git" ]; then
    error_exit "A Git repository already exists in $(pwd). Aborting."
fi

# Initialize Git
git init || error_exit "Failed to initialize Git repository."

# Copy template files
cp "$GITIGNORE_TEMPLATE_PATH" .gitignore || error_exit "Failed to copy .gitignore template."


git add .gitignore || error_exit "Failed to add files to Git."
git commit -m "$INITIAL_COMMIT_MESSAGE" || error_exit "Failed to create initial commit."
git branch -M main

echo "Project successfully initialized in $(pwd)."
