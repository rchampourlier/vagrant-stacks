This repository contains the essential components required to start building you own provisioned [Vagrant](http://www.vagrantup.com) boxes.

## Getting started

Here is a simple walkthrough on how to use this repository to provision a Vagrant box with the `ruby-1.9.2-p290-pg-mongodb` configuration. You can select a configuration amongst the ones describe below in "Available configurations".

### Prepare the repository

We first need to prepare this repository with the required tools and cookbooks for [Chef-Solo](http://wiki.opscode.com/display/chef/Chef+Solo). Chef-Solo is used to provision the box automatically.

```
$ gem install librarian
$ librarian-chef install
```

The first line installs [Librarian](https://github.com/applicationsonline/librarian), a small tool helping us with managing the Chef's cookbooks. The second let it fetch the required cookbooks (which are defined within `Cheffile`, and get installed under `cookbooks`).

### Select the appropriate `Vagrantfile`

A `Vagrantfile` is required to configure how Vagrant will run. There are predefined files available under `vagrantfiles` depending on which configuration you want to provision. Since we assume in this walkthrough you want to provision a `ruby-1.9.2-p290-pg-mongodb` box, let's run this:

```
$ cp vagrantfiles/ruby-1.9.2-p290-pg-mongodb_Vagrantfile ./Vagrantfile
```

This copies the appropriate Vagrantfile in the current directory, so that Vagrant can use it.

### Launch the process

The last step is to have Vagrant *up* the box. Thanks to the `Vagrantfile` we selected, it will select and download the appropriate base box, and run the provisioning necessary operations. We'll end up with a running Vagrant box provisoned according to the selected configuration.

```
$ vagrant up
```

### Package the box

You will surely want to package this box so you can reuse the provisoned environment in your own projects. I invite you to follow [Vagrant's documentation](http://vagrantup.com/docs/getting-started/packaging.html) for this part!

## Available configurations

* **ruby-1.9.2-p290-pg-mongodb**

  A `lucid32` Vagrant base box with some additional components:
  * base: build-essential and git (client)
  * ruby: a **ruby 1.9.2-p290** stack managed with **rbenv**, **Bundler** installed globally and managing gems under project's `vendor/bundle` directory (defined in `vagrant`'s user `~/.bundle/config`)
  * postgresql: a PostgreSQL 8.4 package install from default repo
  * mongodb: a MongoDB package install from mongo's repo
  
## TODO

* Script the whole thing so that once a configuration is chosen, installing Librarian and the cookbooks, selecting the `Vagrantfile` , upping the machine and packaging is done through a single command.