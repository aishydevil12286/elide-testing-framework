#!/bin/bash
# This script will build the project.

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
  echo -e "Build Pull Request #$TRAVIS_PULL_REQUEST => Branch [$TRAVIS_BRANCH]"
  ./gradlew -Pversioneye.api_key=$VERSIONEYE_API_KEY build
elif [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_TAG" == "" ]; then
  echo -e 'Build Branch with Snapshot => Branch ['$TRAVIS_BRANCH']'
  ./gradlew -Pversioneye.api_key=$VERSIONEYE_API_KEY -Prelease.travisci=true snapshot
elif [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_TAG" != "" ]; then
  echo -e 'Build Branch for Release => Branch ['$TRAVIS_BRANCH']  Tag ['$TRAVIS_TAG']'
  case "$TRAVIS_TAG" in
  *-rc\.*)
    ./gradlew -Pversioneye.api_key=$VERSIONEYE_API_KEY -Prelease.travisci=true -Prelease.useLastTag=true candidate --info
    ;;
  *)
    ./gradlew -Pversioneye.api_key=$VERSIONEYE_API_KEY -Prelease.travisci=true -Prelease.useLastTag=true final --info
    ;;
  esac
else
  echo -e 'WARN: Should not be here => Branch ['$TRAVIS_BRANCH']  Tag ['$TRAVIS_TAG']  Pull Request ['$TRAVIS_PULL_REQUEST']'
  ./gradlew -Pversioneye.api_key=$VERSIONEYE_API_KEY build
fi
