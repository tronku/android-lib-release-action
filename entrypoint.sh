#!/bin/sh
set -eou pipefail

GITHUB_TOKEN=$1
default_branch=$2
base_branch=$3
version_file_path=$4
should_sync=$5

if [ "$should_sync" = false ] ; then
  # version bump
  chmod +x /prod_version_bump.sh
  /prod_version_bump.sh $version_file_path $default_branch

  # release version
  version_name=$(/get-app-version.sh $version_file_path)
  release_version=release/v$version_name
  echo $release_version

  # get changelogs
  pr_allow_empty="true"
  pr_title="Going live | $release_version"
  pr_body=$(/get-changelog.sh $base_branch $release_version)

  # create a PR
  echo "pr body: $pr_body"
  chmod +x /createpr.sh
  /createpr.sh "$GITHUB_TOKEN" "$release_version" "$base_branch" "$pr_allow_empty" "$pr_title" "$pr_body"
else
  # Syncing default and base branches
  chmod +x /merge.sh
  /merge.sh $default_branch $base_branch
fi