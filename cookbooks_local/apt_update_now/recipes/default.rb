execute "apt-get update now" do
  command "apt-get update"
  ignore_failure true
  action :nothing
end.run_action(:run)