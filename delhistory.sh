#!/bin/bash
git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch *.aar' --prune-empty --tag-name-filter cat -- --all
git push origin master --force