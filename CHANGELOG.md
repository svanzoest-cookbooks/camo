camo Cookbook Changelog
==========================
This file is used to list changes made in each version of the camo cookbook.

v0.2.2 (unreleased)
-------------------

- [GH-6] Added CentOS Support
- [GH-6] Changed `camo.user` default to `camo` and create the user if it does not exist.
- [GH-6] Added `camo.init_style` to allow for `runit` and `systemd` in addition to previous `upstart`
- Update to camo v2.2.0 and add `camo.keep_alive` attribute support

v0.2.0 (2014-10-29)
-------------------

- Added `camo.install_method` which can be `package` or `deploy_revision`
- Added `camo.header_via`, `camo.length_limit`, `camo.socket_timeout`, `camo.timing_allow_origin` attributes
- Removed `camo.host_exclusions` attribute (no longer supported by camo)
- FC045: Set cookbook name in metadata
- Changed default `deploy_user` to `root`
- Added dependency on `git` for `deploy_revision`
- Update Development environment with Berkshelf, ChefSpec, Test-Kitchen

v0.1.0 (2012-11-10)
-------------------

- Initial Release
