Vagrant.configure('2') do |config|
  trema_home = '/home/vagrant/trema/'
  config.vm.box = 'hfm4/centos7'
  config.vbguest.auto_update = false
  config.vm.synced_folder '.', trema_home
  config.vm.provision 'shell', inline: <<-SHELL
    sudo yum update
    sudo yum install -y ruby ruby-devel gcc gcc-c++ git
    sudo yum install -y https://rdoproject.org/repos/rdo-release.rpm
    sudo yum install -y openvswitch
    sudo systemctl start openvswitch.service
    sudo systemctl enable openvswitch.service
    sudo gem install bundler
  SHELL
  config.vm.provision 'shell', privileged: false, inline: <<-SHELL
    mkdir -p #{trema_home}
    cd #{trema_home}
    bundle install --binstubs --path=vendor/bundle
  SHELL
end
