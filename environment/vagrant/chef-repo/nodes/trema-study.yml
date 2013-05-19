#
# Cookbook Name:: trema
# Recipe:: default
#

%w{gcc make rubygems ruby-devel irb libpcap-devel sqlite-devel}.each do |pkg| package pkg do
    action :install
  end
end

%w{trema rspec}.each do |gem| gem_package gem do
    action :install
  end
end
