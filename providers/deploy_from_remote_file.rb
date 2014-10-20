use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

action :deploy do
  remote_file "#{new_resource.path_tmp_download}/#{new_resource.file_deploy}" do    
    source "#{new_resource.base_url_deploy}/#{new_resource.file_deploy}"
    if ::File.exists?("#{new_resource.path_tmp_download}/#{new_resource.file_deploy}")
      headers "If-Modified-Since" => ::File.mtime("#{new_resource.path_tmp_download}/#{new_resource.file_deploy}").httpdate
    end
    action :create
  end
  update_package
end

def update_package
  if ::File.exists?("#{new_resource.path_tmp_download}/#{new_resource.file_deploy}")
    checksumFile = ::File.mtime("#{new_resource.path_tmp_download}/#{new_resource.file_deploy}").httpdate
    if ::File.exists?("#{new_resource.path_tmp_download}/checksum")  
      checkSumActual = IO.read("#{new_resource.path_tmp_download}/checksum")
    end
    if checksumFile != checkSumActual
      execute "copy_files_to_apps_mule" do
        command "cp #{new_resource.path_tmp_download}/#{new_resource.file_deploy} #{new_resource.path_apps}"
      end   
    end  
    status_file = "#{new_resource.path_tmp_download}/checksum"
    file status_file do
      owner 'root'
      group 'root'
      mode '0600'
      content ::File.mtime("#{new_resource.path_tmp_download}/#{new_resource.file_deploy}").httpdate
    end
  end
end