#
# Cookbook Name:: postgresql_server_utf8
# Recipe:: default
#
# Copyright 2012 (c) softr.li (Romain Champourlier <romain@softr.li>)
#

include_recipe "set_locale"

# TODO
# Test if already installed, if not run "recipe[apt_update_now]" so that
# apt gets updated which may prevent some errors.
#
ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"
include_recipe "postgresql::server"