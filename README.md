
# Module `terraform-google-redis`

Core Version Constraints:
* `>= 0.13`

Provider Requirements:
* **google-beta (`hashicorp/google-beta`):** (any version)

## Input Variables
* `environment` (required): Company environment for which the resources are created (e.g. dev, tst, acc, prd, all).
* `instance_defaults` (required): Redis instance defaults
* `instances` (required): Map of Redis instances to be created. The key will be used for the instance name so it should describe the purpose. The value can be a map with the following keys to override default settings:
  * display_name
  * tier
  * memory_size_gb
  * redis_version
  * region
  * location_id
  * alternative_location_id
  * authorized_network
  * connect_mode
  * reserved_ip_range
  * labels
  * owner

* `owner` (required): Owner of the resource. This variable is used to set the 'owner' label.
* `project` (required): Company project name.

## Output Values
* `instance_defaults`: The generic defaults used for Redis instances
* `map`: outputs for all redis_instances created

## Managed Resources
* `google_redis_instance.map` from `google-beta`

## Creating a new release
After adding your changed and committing the code to GIT, you will need to add a new tag.
```
git tag vx.x.x
git push --tag
```
If your changes might be breaking current implementations of this module, make sure to bump the major version up by 1.

If you want to see which tags are already there, you can use the following command:
```
git tag --list
```
Required APIs
=============
For the VPC services to deploy, the following APIs should be enabled in your project:
 * `redis.googleapis.com`
 * `cloudresourcemanager.googleapis.com`

Testing
=======
This module comes with [terratest](https://github.com/gruntwork-io/terratest) scripts for both unit testing and integration testing.
A Makefile is provided to run the tests using docker, but you can also run the tests directly on your machine if you have terratest installed.

### Run with make
Make sure to set GOOGLE_CLOUD_PROJECT to the right project and GOOGLE_CREDENTIALS to the right credentials json file
You can now run the tests with docker:
```
make test
```

### Run locally
From the module directory, run:
```
cd test && TF_VAR_owner=$(id -nu) go test
```
