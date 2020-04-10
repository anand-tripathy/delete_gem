# delete_gem
Github action to delete gem already present in github package for same version

## Inputs
### `package-name`
**Required** The name of the package to be deleted
### `organization-name`
**optional** The name of the organization if package belongs to organisation account
### `repo-name`
**optional** The name of the repo if package is in different repo
### `token`
**optional** secret token if you don't want to use GITHUB_TOKEN

## Example usage


```
jobs:
  build:
    name: Build + Publish
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - name: Set up Ruby 2.6
      uses: actions/setup-ruby@v1
      with:
        version: 2.6.x
    - name: Delete Gem
      uses: guptalakshya92/delete_gem@v1
      with:
        package-name: your-package-name
        organisation-name: your-organization-name
      env:
        GITHUB_TOKEN: ${{secrets.GITHUB_TOKEN}}
        OWNER: username
```
