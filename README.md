# Library Release Action

It is used to bump current library's version and publish a new package and release tag.

## Params required
```yaml
inputs:
  github_token:
    description: 'GitHub token to access your repo'
    required: true

  default_branch:
    description: 'Default branch of the repo'
    required: false
    default: 'development'

  main_branch:
    description: 'Main branch of the repo for release'
    required: false
    default: 'master'

  should_sync:
    description: 'Should sync default and main branch (for release only)'
    required: false
    default: 'false'

  auto_delete:
    description: 'Should delete old packages'
    required: false
    default: 'false'
    
  delete_version_count: 
    description: 'Number of versions to be deleted'
    required: false
    default: '10'

  packages_count:
    description: 'Number of packages in the repo'
    required: false
    default: '1'  
    
  package_file_path:
    description: 'Path of package.properties file'
    required: false
    default: 'package.properties'  

  version_file_path:
    description: 'Path of version.properties file'
    required: false
    default: 'version.properties' 

  release_branch_prefix:
    description: 'Prefix of the version bump release branch'
    required: false
    default: ''
```

## How to use
- To bump the version, `should_sync` is not required.
```yaml
uses: Zomato/android-lib-release-action@v4
with:
  github_token: ${{ secrets.GITHUB_TOKEN }}
  default_branch: development
  main_branch: master
  version_file_path: version.properties
```

- To sync default and main branch, `should_sync` should be set to `true`.
```yaml
uses: Zomato/android-lib-release-action@v4
with:
  github_token: ${{ secrets.GITHUB_TOKEN }}
  default_branch: development
  main_branch: master
  version_file_path: version.properties
  should_sync: true
```

- To enable package deletion, `auto_delete` should be set to `true`.
```yaml
uses: Zomato/android-lib-release-action@v4
with:
  github_token: ${{ secrets.GITHUB_TOKEN }}
  default_branch: development
  package_file_path: package.properties
  delete_version_count: 1
  packages_count: 1
  auto_delete: true
```


### Requestor
Shubham Pathak - shubham.pathak@zomato.com
