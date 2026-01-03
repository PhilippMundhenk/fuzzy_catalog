#!/bin/bash
# Updates version in mix.exs for cog pre-bump hook
# Cog provides the new version as the first argument

set -e

VERSION="${1}"

if [ -z "$VERSION" ]; then
    echo "Error: No version provided"
    exit 1
fi

sed -i '' "s/version: \"[^\"]*\"/version: \"${VERSION}\"/" mix.exs
git add mix.exs
