actions :configure
default_action :configure

attribute :app_name, :kind_of => String, :default => 'app_mule'
attribute :key_log_sentry, :kind_of => String, :default => nil
attribute :dir_mule, :kind_of => String, :default => nil
attribute :url_chef_download_files, :kind_of => String, :default => nil

def initialize(*args)
  super
  @action = :configure
end
