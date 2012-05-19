Vagrant::Config.run do |config|

  # The box and its URL
  config.vm.box = "lucid32"
  config.vm.box_url = "http://files.vagrantup.com/lucid32.box"

  # Boot with a GUI so you can see the screen. (Default is headless)
  # config.vm.boot_mode = :gui

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks. (Plus this prevent the issue
  # that may show up sometimes when starting a box in NAT networking mode, see
  # https://github.com/mitchellh/vagrant/issues/455)
  config.vm.network :hostonly, "10.10.10.2"

  # Tries to fix issue #455
  config.vm.customize ["modifyvm", :id, "--rtcuseutc", "on"]
  config.ssh.max_tries = 10

  # Assign this VM to a bridged network, allowing you to connect directly to a
  # network using the host's network device. This makes the VM appear as another
  # physical device on your network.
  # config.vm.network :bridged

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  config.vm.forward_port 3000, 3333 # port-forwarding for development rails server

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  # config.vm.share_folder "v-data", "/vagrant_data", "../data"

  # Enables NFS shared folders to improve performance 
  config.vm.share_folder("v-root", "/vagrant", ".", :nfs => true)

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding 
  # some recipes and/or roles.
  
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["./cookbooks", "./cookbooks_local"]
    chef.roles_path = "./roles"
    #chef.data_bags_path = "./data_bags"

    dna = JSON.parse(File.read(File.join(File.dirname(__FILE__), 'chef_dnas', 'ruby-1.9.2-p290-pg-mongodb.json')))
    dna.delete("run_list").each do |run_item|
      regexp = %r{(role|recipe)\[([\w:]+)\]}
      eval "chef.add_#{run_item[regexp, 1]} '#{run_item[regexp, 2]}'"
    end

    chef.json = dna
  end

  # Enable provisioning with chef server, specifying the chef server URL,
  # and the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for
  # ORGNAME in the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be
  # HTTP instead of HTTPS depending on your configuration. Also change the
  # validation key to validation.pem.
  #
  # config.vm.provision :chef_client do |chef|
  #   chef.chef_server_url = "https://api.opscode.com/organizations/ORGNAME"
  #   chef.validation_key_path = "ORGNAME-validator.pem"
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # IF you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "ORGNAME-validator"
end
