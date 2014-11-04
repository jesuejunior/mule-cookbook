actions :deploy
default_action :deploy

attribute :base_url_deploy, :kind_of => String, :default => nil
attribute :file_deploy, :kind_of => String, :default => nil
attribute :path_apps, :kind_of => String, :default => nil
attribute :path_tmp_download, :kind_of => String, :default => nil
attribute :mail_to, :kind_of => String, :default => node['smtp']['mail_to']

def initialize(*args)
  super
  @action = :deploy
end