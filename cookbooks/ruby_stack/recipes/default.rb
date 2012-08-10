#
# Cookbook Name:: rbenv
# Recipe:: default
#
# Copyright 2011, Fletcher Nichol
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "ruby_build"

rubies = Array(node['ruby_stack']['rubies'])

gems = (rubies.inject({}) do |hash, rubie|
  hash.merge!({ rubie => [{ 'name' => 'bundler' }] })
end)

node['rbenv']['user_installs'] = Array(node['ruby_stack']['users']).inject([]) do |array, user|
  array.push({
    'user'      => user,
    'rubies'    => node['ruby_stack']['rubies'],
    'global'    => node['ruby_stack']['global'],
    'gems'      => gems
  })
  array
end

include_recipe "rbenv::user"

# If 'ruby_stack'['vendor_gems'] is present and true, create the ~/.bundle/config file for
# each indicated users. Configures Bundler to manage gems under project's vendor/bundle directory.
if node['ruby_stack']['vendor_gems']
  Array(node['ruby_stack']['users']).each do |user_name|
    user_dir = Etc.getpwnam(user_name).dir

    directory File.join(user_dir, ".bundle") do
      owner user_name
      group user_name
      mode "0755"
      action :create
    end

    template "#{user_dir}/.bundle/config" do
      source  "bundle_config.erb"
      owner user_name
      group user_name
      mode "0644"
    end
  end
end