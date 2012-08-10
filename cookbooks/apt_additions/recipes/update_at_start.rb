execute "apt-get-update-at-start" do
  command "apt-get update"
  ignore_failure true
  action :nothing
end.run_action(:run)