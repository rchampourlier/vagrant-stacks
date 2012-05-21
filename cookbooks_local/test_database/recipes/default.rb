#
# Cookbook Name:: test_database
# Recipe:: default
#
# Copyright 2012 (c) softr.li (Romain Champourlier <romain@softr.li>)
#

ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"
include_recipe "postgresql::server"

db_connection_info = {
  :host => "127.0.0.1",
  :port => 5432,
  :username => 'postgres',
  :password => 'password'
}

database_user 'test' do
  provider Chef::Provider::Database::PostgresqlUser
  connection db_connection_info
  password 'password'
  action :create
end

postgresql_database 'test' do
  connection({
    :host => "127.0.0.1",
    :port => 5432,
    :username => 'postgres',
    :password => node['postgresql']['password']['postgres']
  })
  owner 'test'
  encoding 'UTF8'
  action :create
end
