#run mule
# execute "run_mule"  do
#   command "#{node['mule']['install_dir']}/#{node['mule']['dir']}/bin/mule start"
#   action :run
# end

cookbook_file "/etc/init/mule.conf" do
  source "mule-upstart.conf"
end

service "mule" do
  supports :status => true, :restart => true, :start => true, :reload => false
  provider Chef::Provider::Service::Upstart
  action :start
  not_if 'status mule | grep start'
end



