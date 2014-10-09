use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

action :configure do
  FILE_RAVEN="raven-4.2.jar"
  FILE_RAVEN_LOG4J="raven-log4j-4.2.jar"
  URL_DOWNLOAD_RAVEN="#{new_resource.url_chef_download_files}/#{FILE_RAVEN}"
  URL_DOWNLOAD_RAVEN_LOG4J="#{new_resource.url_chef_download_files}/#{FILE_RAVEN_LOG4J}"
  DIR_LIB_MULE="#{new_resource.dir_mule}/lib/mule"
  DIR_LOG4J_PROPERTIES_MULE="#{new_resource.dir_mule}/conf/log4j.properties"


  remote_file "#{DIR_LIB_MULE}/#{FILE_RAVEN}" do    
    source "#{URL_DOWNLOAD_RAVEN}"
    if ::File.exists?("#{DIR_LIB_MULE}/#{FILE_RAVEN}")
      headers "If-Modified-Since" => ::File.mtime("#{DIR_LIB_MULE}/#{FILE_RAVEN}").httpdate
    end
    action :create
  end
  remote_file "#{DIR_LIB_MULE}/#{FILE_RAVEN_LOG4J}" do    
    source "#{URL_DOWNLOAD_RAVEN_LOG4J}"
    if ::File.exists?("#{DIR_LIB_MULE}/#{FILE_RAVEN_LOG4J}")
      headers "If-Modified-Since" => ::File.mtime("#{DIR_LIB_MULE}/#{FILE_RAVEN_LOG4J}").httpdate
    end
    action :create
  end
	
	template "#{DIR_LOG4J_PROPERTIES_MULE}" do
	  source 'sentry/log4j.erb'
	  variables ({
	    :app_name => new_resource.app_name,
	    :key_log_sentry => new_resource.key_log_sentry,
	  })
	end

end