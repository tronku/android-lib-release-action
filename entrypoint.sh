#!/bin/sh
set -eou pipefail

GITHUB_TOKEN=$1
default_branch=$2
base_branch=$3
version_file_path=$4
should_sync=$5
auto_delete=$6
delete_version_count=$7
packages_count=$8
package_file_path=$9

if [ "$auto_delete" = true ] ; then
  source $version_file_path
  current_version=${VERSION_NAME//./}
  source $package_file_path
  last_version=$LAST_DELETED_VERSION

  versions_count=$(expr "$current_version" - "$last_version")
  echo "Current version - $current_version"
  echo "Last deleted version - $last_version"
  echo "Versions count - $versions_count"

  if [ $versions_count <= $delete_version_count ] ; then
    echo "Not enough versions to delete."
  else
    echo "Old versions can be deleted."
    python3 /delete_old_packages.py "$GITHUB_TOKEN" "$GITHUB_REPOSITORY" $packages_count $delete_version_count "$package_file_path" $default_branch
  fi
elif [ "$should_sync" = false ] ; then
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