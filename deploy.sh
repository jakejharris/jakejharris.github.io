#!/bin/bash

# The branch you want to deploy your `dist` directory to
DEPLOY_BRANCH="gh-pages"

# Make sure we're starting from a clean state
if [[ -n $(git status -s) ]]
then
  echo "Error: Please commit your changes first."
  exit 1
fi

# Checkout to the deploy branch
git checkout $DEPLOY_BRANCH || git checkout --orphan $DEPLOY_BRANCH

# If we're on the deploy branch, reset it to the latest version of the main branch
# This assumes that your main branch is called 'main'
git reset --hard main

# Delete all files to make room for the new dist content
# Be careful with this command; it deletes all files not in .git
git rm -rf .

# Copy the contents of the dist directory into the root of the project
# This assumes your dist directory has the html, css, and js subdirectories
cp -r dist/* .

# Add all files in the root directory (which now contains the dist content)
git add .

# Commit the changes
git commit -m "Deploy website"

# Push to the deploy branch on the remote
# Force push if you want to overwrite the history on the deploy branch
git push origin $DEPLOY_BRANCH --force

# Checkout back to the main branch
git checkout main