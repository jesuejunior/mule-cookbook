actions :deploy
default_action :deploy

attribute :base_url_deploy, :kind_of => String, :default => nil
attribute :file_deploy, :kind_of => String, :default => nil
attribute :path_apps, :kind_of => String, :default => nil
attribute :path_tmp_download, :kind_of => String, :default => nil

def initialize(*args)
  super
  @action = :deploy
end