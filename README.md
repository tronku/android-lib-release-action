# Library Release Action

It is used to bump current library's version and publish a new package and release tag.

## Params required
```yaml
inputs:
  github_token:
    description: 'Github token to access your repo'
    required: true

  default_branch:
    description: 'Default branch of the repo'
    required: false
    default: 'development'

  main_branch:
    description: 'Main branch of the repo for release'
    required: false
    default: 'master'

  version_file_path:
    description: 'Path of version.properties file'
    required: true

  release_tag:
    description: 'Should release tag or not'
    required: true
    default: false  
```

## How to use
- To bump the version, `release_tag` is not required.
```yaml
uses: Zomato/android-lib-release-action@master
with:
	github_token: ${{ secrets.GITHUB_TOKEN }}
	default_branch: development
	main_branch: master
	version_file_path: version.properties
```

- To publish the package, `release_tag` should be set to `true`
```yaml
uses: Zomato/android-lib-release-action@master
with:
	github_token: ${{ secrets.GITHUB_TOKEN }}
	default_branch: development
	main_branch: master
	version_file_path: version.properties
	release_tag: true
```

### Requestor
Shubham Pathak - shubham.pathak@zomato.com
