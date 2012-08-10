# Script to ease downloading of cookbooks from Opscode repo and Github
# by using a YAML file to describe the necessary cookbooks.

require 'yaml'
require 'fileutils'

script_dir = File.expand_path('.')
cookbooks_dir = File.join(script_dir, 'cookbooks')
archives_dir = File.join(script_dir, 'cookbooks_archives')

# Constants

config_file_name = 'ingredients.yml'
config_file_path = config_file_name

# Code

if File.exists?(config_file_path)
  
  begin
    config = YAML.load(File.open(config_file_path).read)
  rescue Psych::SyntaxError => e
    raise "#{config_file_name} has incorrect syntax >> #{e}"
  end

else
  raise "#{config_file_name} is not present"
end

cookbooks = config['cookbooks']

# Downloading the changed cookbooks

pending_archives = []
FileUtils::makedirs(archives_dir)
Dir.chdir(archives_dir)

# From Opscode community repo

cookbooks['opscode'].each do |name, version|
  
  archive_name = "#{name}-#{version}.tar.gz"
  unless File.exists?(archive_name)
    response = %x{knife cookbook site download #{name} #{version} 2>&1}
    
    case response
    when %r{ERROR: The object you are looking for could not be found}
      raise "Cookbook #{name} #{version} could not be found in Opscode Community repository (using knife)"
      
    when %r{ERROR}
      raise "Error: an error append when trying to download cookbook #{name} #{version} (using knife)"

    else
      puts "Downloaded: #{archive_name}"
    end
  
  else
    puts "Ignored: #{archive_name} (already downloaded)"
  end

  pending_archives << archive_name
end


def repo_owner_from_repo(repo)
  repo[%r{https://github.com/([^/]*)}, 1]
end

def repo_name_from_repo(repo)
  repo[%r{https://github.com/(?:[^/]*)/([^/]*)}, 1]
end

def archive_name_for_git_cookbook(name, hash)
  "#{repo_owner_from_repo(hash['repo'])}_#{repo_name_from_repo(hash['repo'])}_#{name}-#{hash['ref']}.tar.gz"
end

# From git
cookbooks['git'].each do |name, hash|
  # hash => { :repo => '...', :ref => '...' }

  archive_name = archive_name_for_git_cookbook(name, hash)
  tarball_url = "#{hash['repo']}/tarball/#{hash['ref']}"

  unless File.exists?(archive_name) && !hash['force_reload']
    response = %x{curl -L #{tarball_url} -o #{archive_name} 2>&1}

    case response
    when %r{Could not resolve host}
      raise "Invalid repo URL: #{hash['repo']}"
    else
      begin
        if File.open(archive_name).read =~ %r{(Not found|404)}
          raise "Repo not found for this URL: #{tarball_url}"
        end
      rescue ArgumentError
        # This is OK, we're trying to read as UTF a compressed tarball
      end
      puts ["Downloaded: #{archive_name}", hash['force_reload'] ? '(forced)' : nil].compact.join(' ')
    end

  else
    puts "Ignored: #{archive_name} (already downloaded)"
  end

  pending_archives << archive_name
end

Dir.chdir(script_dir)

# Clear current cookbooks
%x[rm -Rf cookbooks]
FileUtils::makedirs('cookbooks')

Dir.chdir(cookbooks_dir)

pending_archives.each do |archive_name|
  response = %x{tar zxf #{File.join(archives_dir, archive_name)} 2>&1}

  case response
  when %r{Error opening archive: Failed to open}
    raise "Error when trying to open archive #{archive_name}"
  end

  puts "Extracted: #{archive_name}"
end

# Renaming cookbooks from git
cookbooks['git'].each do |name, hash|

  %x{mv #{repo_owner_from_repo(hash['repo'])}*#{name}* #{name}}
end