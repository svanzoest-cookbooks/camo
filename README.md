camo cookbook
================
[![Build Status](https://travis-ci.org/svanzoest-cookbooks/camo.png?branch=master)](https://travis-ci.org/svanzoest-cookbooks/camo)
[![Join the chat at https://gitter.im/svanzoest-cookbooks/camo](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/svanzoest-cookbooks/camo?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Description
===========

Installs camo - a small http proxy to simplify routing images through an SSL host
For more information on camo see https://github.com/atmos/camo/

Requirements
============

The dependencies are assumed to be downloaded from the Chef Supermarket cookbook repository.

* nodejs cookbook
* git cookbook
* runit cookbook

Usage
=====

Usually you would run this behind a web server proxy, such as `apache2`, `nginx`, `varnish` etc.

In a wrapper cookbook add this cookbook as a dependency and include the default recipe

```ruby
include_recipe 'camo::default'
```

Attributes
==========

## General 

* `node['camo']['user'] = "camo"` - user to run camo as, the cookbook will create the user if it does not exist.
* `node['camo']['group'] = "users"` - group used on directory creation.
* `node['camo']['install_method'] = 'deploy_revision'` - method for installing camo: either `package` or `deploy_revision`.
* `node['camo']['init_style']` - attempts to pick the platform default, but otherwise can be defined as `upstart`, `systemd` or `runit`

## Configuration

These are configuration parameters that will be passed directly to camo via the init scripts.
Please see camo documentation for more details on these attributes.

* `node['camo']['port'] = 8081`
* `node['camo']['header_via'] = nil`
* `node['camo']['key'] = '0x24FEEDFACEDEADBEEFCAFE'`
* `node['camo']['logging'] = "disabled"`
* `node['camo']['length_limit'] = 5242880`
* `node['camo']['max_redirects'] = 4`
* `node['camo']['socket_timeout'] = 10`
* `node['camo']['timing_allow_origin'] = nil`
* `node['camo']['hostname'] = "unknown"`
* `node['camo']['keep_alive'] = false`

## Init Style: Systemd

* `node['camo']['systemd']['env_path'] = '/etc/sysconfig'`

## Install Method: Deploy Revision

This install methods installs directly from source. It is highly recommended that if you use this method that you specify a particular `camo.branch` and
your own fork via `camo.repo`. This will minimize impact of changes by upstream that you do not control.

* `node['camo']['path'] = "/srv/camo"` - location where to install camo
* `node['camo']['deploy_user'] = "root"` - user who will run git and own the deployed repo.
* `node['camo']['deploy_group'] = "users"` - group who will own the deployed repo.
* `node['camo']['deploy_migrate'] = false` - do not run `deploy_revision` migrations
* `node['camo']['deploy_action'] = "deploy"` - action to pass to the `deploy_revision` resource.
* `node['camo']['repo'] = "git://github.com/atmos/camo.git"` - location of the camo git repo.
* `node['camo']['branch'] = "master"` - the branch or tag to clone

# Development

We have written unit tests using [chefspec](http://code.sethvargo.com/chefspec/) and integration tests in [serverspec](http://serverspec.org/) executed via [test-kitchen](http://kitchen.ci). Much of the tooling around this cookbook is exposed via guard and test kitchen, so it is highly recommended to learn more about those tools. The easiest way to get started is to install the [Chef Development Kit](https://downloads.chef.io/chef-dk/)

## Running tests

The following commands will run the tests:

```
chef exec bundle install
chef exec rubocop
chef exec foodcritic .
chef exec rspec
chef exec kitchen test default-ubuntu-1404
chef exec kitchen test default-centos-70
```

The above will do ruby style ([rubocop](https://github.com/bbatsov/rubocop)) and cookbook style ([foodcritic](http://www.foodcritic.io/)) checks followed by rspec unit tests ensuring proper cookbook operation. Integration tests will be run next on two separate linux platforms (Ubuntu 14.04 LTS Precise 64-bit and CentOS 7.0). Please run the tests on any pull requests that you are about to submit and write tests for defects or new features to ensure backwards compatibility and a stable cookbook that we can all rely upon.

## Running tests continuously with guard

This cookbook is also setup to run the checks while you work via the [guard gem](http://guardgem.org/).

```
bundle install
bundle exec guard start
```
