#!/bin/bash

bucketName=$1

if [ -e "/startup/$bucketName/collections.json" ]; then
  echo "Creating scopes and collections in $bucketName..."

  # Create the scopes and collections
  while IFS= read -r scopeName
  do
    echo "Scope: $scopeName"
    # Check to see if the scope name provided is the default scope. If not, create the scope
    if [ "$scopeName" != "_default" ]; then
      echo "Creating scope: $scopeName..."
      curl -Ss -X POST -u "$CB_USERNAME:$CB_PASSWORD" "http://localhost:8091/pools/default/buckets/$bucketName/scopes" --data-urlencode "name=$scopeName" && echo
    fi

    # Create the collections within the appropriate scope
    while IFS= read -r collectionName
    do
      echo "Creating collection: $collectionName..."
      curl -Ss -X POST -u "$CB_USERNAME:$CB_PASSWORD" "http://localhost:8091/pools/default/buckets/$bucketName/scopes/$scopeName/collections" --data-urlencode "name=$collectionName" && echo
    done < <(jq -r --arg scopeName "$scopeName" '.scopes[$scopeName].collections[]' "/startup/$bucketName/collections.json")
  done < <(jq -r '.scopes | keys[]' "/startup/$bucketName/collections.json")
fi
