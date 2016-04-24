#!/bin/bash
# Export factorio mod.
MOD_VERSION=$(grep version info.json | sed 's/[[:alpha:][:space:]":,]//g')
mkdir "../homeworld_$MOD_VERSION"
cp -rf "../factorio-homeworld/" "../homeworld_$MOD_VERSION"
zip -r "../homeworld_$MOD_VERSION.zip" "../homeworld_$MOD_VERSION" --exclude *.git*
echo Exported $MOD_VERSION