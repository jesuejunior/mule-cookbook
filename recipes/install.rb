INSTALL_DIR = node['mule']['install_dir']
DIRECTORY_MULE = node['mule']['dir']
DIRECTORY_MULE_UNZIPED = "mule-enterprise-standalone-3.5.1"
URL_CHEF_SOLO = node['mule']['base_url']
LICENSE_FILE = "mule-ee-license.lic"
ZIP_FILE = "mule-ee-distribution-standalone-3.5.1.zip"
LICENSE_URL = "#{URL_CHEF_SOLO}/#{LICENSE_FILE}"
MULE_URL = "#{URL_CHEF_SOLO}/#{ZIP_FILE}"

# Preparação para o download do mule-enterprise server.
remote_file "#{INSTALL_DIR}/#{ZIP_FILE}" do
  source MULE_URL
  action :nothing
end

# Preparação para o download da licença do Mule Enterprise
remote_file "#{INSTALL_DIR}/#{LICENSE_FILE}" do
  source LICENSE_URL
  action :nothing
end

# Realizando download do mule-enterprise servr efetivamente, somente se houve alterações na data de criação
http_request "HEAD #{MULE_URL}" do
  message ""
  url MULE_URL
  action :head
  if File.exists?("#{INSTALL_DIR}/#{ZIP_FILE}")
    headers "If-Modified-Since" => File.mtime("#{INSTALL_DIR}/#{ZIP_FILE}").httpdate
  end
  notifies :create, resources(:remote_file => "#{INSTALL_DIR}/#{ZIP_FILE}"), :immediately
end

# Realizando download da licença Mule Enterprise efetivamente, somente se houve alterações na data de criação
http_request "HEAD #{LICENSE_URL}" do
  message ""
  url LICENSE_URL
  action :head
  if File.exists?("#{INSTALL_DIR}/#{LICENSE_FILE}")
    headers "If-Modified-Since" => File.mtime("#{INSTALL_DIR}/#{LICENSE_FILE}").httpdate
  end
  notifies :create, resources(:remote_file => "#{INSTALL_DIR}/#{LICENSE_FILE}"), :immediately
end

package "unzip"

#unzip mule
execute "unzip" do
  command "unzip #{INSTALL_DIR}/#{ZIP_FILE} -d #{INSTALL_DIR}"
  action :run
  not_if 'test -d /opt/mule'
end

execute "copy_files_to_directory_mule" do
  command "cp -r #{INSTALL_DIR}/#{DIRECTORY_MULE_UNZIPED} #{INSTALL_DIR}/#{DIRECTORY_MULE}"
  action :run
  not_if 'test -d /opt/mule'
end

directory "#{INSTALL_DIR}/#{DIRECTORY_MULE_UNZIPED}" do
  recursive true
  action :delete
end

#install license
execute "run_install_license"  do
  command "#{INSTALL_DIR}/#{DIRECTORY_MULE}/bin/mule -installLicense #{INSTALL_DIR}/#{LICENSE_FILE}"
  action :run
end