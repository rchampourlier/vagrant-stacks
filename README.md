# Setup your development machine

## Getting started

```
cd machines
vagrant up
```

## Presentation

### Vagrant

The development machine setup is provided by Vagrant. The `Vagrantfile` specifies the Vagrant box to be used and how to link it to your machine's environment (SSH tunnelling, port forwarding, directory sync, etc.).

The machine is currently based on the `lucid` Vagrant base box (Ubuntu 10.04.3 LTS, which is the same as on the production server).

### Provisioning with Chef

The development environment (Ruby stack with rbenv, databases, and other required services) is setup through a Chef recipe (`development.json`, using `cookbooks` and `roles`).

### Bundling the required cookbooks with Librarian

The cookbooks for this recipe are defined in the `Cheffile`. You will need to gather them using Librarian:

```
cd machines
gem install librarian
librarian-chef install
```
Once installed, the cookbooks are kept in `cookbooks`. They will be committed to the git repo, so installing them is only needed when adding a new cookbook.
