#!/bin/bash

# Configuration
DEPLOY_BRANCH="gh-pages"
MAIN_BRANCH="main"

# Function to print an error and exit
error() {
  echo "Error: $1" >&2
  exit 1
}

# Make sure we're on the main branch
echo "Checking out to $MAIN_BRANCH branch..."
git checkout $MAIN_BRANCH || error "Could not checkout to $MAIN_BRANCH. Make sure it exists and is clean."

# Ensure the working tree is clean
if [[ -n $(git status -s) ]]; then
  error "The working directory is not clean. Please commit or stash your changes."
fi

# Checkout to the deploy branch or create it if it doesn't exist
echo "Preparing the $DEPLOY_BRANCH branch..."
if git show-ref --verify --quiet "refs/heads/$DEPLOY_BRANCH"; then
  git checkout $DEPLOY_BRANCH || error "Could not checkout to $DEPLOY_BRANCH."
  git reset --soft $MAIN_BRANCH || error "Could not reset $DEPLOY_BRANCH to $MAIN_BRANCH."
else
  git checkout --orphan $DEPLOY_BRANCH || error "Could not create orphan $DEPLOY_BRANCH."
fi

# Clean the current deploy branch except .git folder
echo "Removing old files..."
git rm -rfq . && git clean -fdxq --exclude=".git"

# Copy the new dist content to the root of the gh-pages branch
echo "Copying new content to $DEPLOY_BRANCH branch..."
cp -a dist/html/. .
cp -a dist/css/. css/
