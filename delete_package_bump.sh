# Deletes versions of given packages using ids
GITHUB_TOKEN=$1
package_file_path=$2
default_branch=$3
version_deleted=$4

# Updating last_version
source $package_file_path
last_version=$LAST_DELETED_VERSION
last_version=`expr $last_version + $version_deleted`

git config user.name ${GITHUB_ACTOR}
git config user.email ${GITHUB_ACTOR}@zomato.com

deletionBranch=deletionVersion/$last_version

git checkout $default_branch
git checkout -b $deletionBranch
git reset --hard origin/$default_branch

# updating package.properties
cat > $package_file_path <<EOF
LAST_DELETED_VERSION=$last_version
EOF

echo "Last deleted version: $last_version"

# Commit and push
git add $package_file_path
git commit -m "Updating deleted version: $last_version"
git push origin $deletionBranch --force

# get changelogs
pr_allow_empty="true"
pr_title="Package file bump | $deletionBranch"
pr_body=$(/get-changelog.sh $default_branch $deletionBranch)

# create a PR
echo "pr body: $pr_body"
chmod +x /createpr.sh
/createpr.sh "$GITHUB_TOKEN" "$deletionBranch" "$default_branch" "$pr_allow_empty" "$pr_title" "$pr_body"