#!/usr/bin/env bash
for d in */ ; do
    echo "$d"
    git diff --name-only HEAD^ HEAD $d
done
