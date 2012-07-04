This repository contains the essential components required to start building and packaging you own provisioned [Vagrant](http://www.vagrantup.com) boxes.

This repo will help you to shorten the path to provision you Vagrant box (i.e. install the components you need, such as a Ruby stack, some databases).

Using one of the *Available configurations*, you can **build a provisioned Vagrant box** with some commands, **without even having to write a Chef recipe for the provisioning**!

Once your box is up, package it so that you can reuse it in others project without having to provision the box each time you need it (Ruby compilation can take some time).

## Getting started

Here is a simple walkthrough on how to use this repository to provision a Vagrant box with the `ruby-1.9.2-p290-pg-mongodb` configuration. You can select a configuration amongst the ones describe below in "Available configurations".

### Prerequisites

- Ruby
- Vagrant

### Clone and prepare the repository

First, we clone the repository.

```
git clone https://github.com/rchampourlier/vagrant-stacks.git
cd vagrant-stacks
```

We then need to fetch the cookbooks we will use with [Chef-Solo](http://wiki.opscode.com/display/chef/Chef+Solo). (Chef-Solo is used to provision the box automatically.)

To manage the cookbooks easily, we use [Librarian](https://github.com/applicationsonline/librarian).

```
$ gem install librarian
$ librarian-chef install
```

The first line installs Librarian, while the second lets it fetch the required cookbooks (which are defined within `Cheffile`, and get installed under `cookbooks`).

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

You will surely want to package this box so you can reuse the provisoned environment in your own projects.

*Packaging is described in this [Vagrant's documentation](http://vagrantup.com/docs/getting-started/packaging.html).
*

If you have prepared the box with `vagrant up`, you should now be able to export it simply and quickly with this command:

```
vagrant package
```

If everything goes well, this should create a `package.box` with your newly provisioned Vagrant box! Congratulations!

Now you can share it with your team, place it on any file server, and reuse it in new projects by simpling using this in your project's `Vagrantfile`:

```
# The box and its URL
config.vm.box = "ruby-1.9.2-p290-pg-mongodb"
config.vm.box_url = "http://your-file-server.com/ruby-1.9.2-p290-pg-mongodb.box"
```

Should you just want to use your box from your local filesystem, comment the `config.vm.box_url...` line out, and run:

```
vagrant box add ruby-1.9.2-p290-pg-mongodb path/to/your/ruby-1.9.2-p290-pg-mongodb.box
```

**Enjoy!**

## Available configurations

* **ruby-1.9.2-p290-pg-mongodb**
  * Base box:
    * `lucid32` (Ubuntu 10.04.3 LTS) base box from [vagrantbox.es](http://vagrantbox.es)
    * Default locale (`en_US`) changed to (`en_US.UTF8`). See used `postgresql_server_utf8` cookbook for more details.
  * Provisioned software:
	  * **base**: build-essential and git (client)
	  * **ruby**: a *ruby 1.9.2-p290* stack managed with *rbenv*, *Bundler* installed globally (default gems management - within rbenv's directory)
	  * **postgresql**: a PostgreSQL 8.4 package install from default repo (`postgres`' user password is... `password`). Compatible with UTF8 thanks.
	  * **mongodb**: a MongoDB package install from mongo's repo
  * This box is available packaged [here](http://cdn.hubic.me/UqribXpHZqNp/ruby-1.9.2-p290-pg-mongodb.box).
  
## Fork!

You're free to fork and submit pull requests if you want to add new configurations, or build some tools around this!

## TODO

* Script the whole thing so that once a configuration is chosen, installing Librarian and the cookbooks, selecting the `Vagrantfile` , upping the machine and packaging is done through a single command.

## Copyright and License

Copyright (c) 2012, Romain Champourlier

### MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.