VAGRANTFILE_API_VERSION = '2'

require 'yaml'

# Carrega as configurações do ambiente
env_config = YAML.load_file('environment.yaml')

# Versão mínima do Vagrant
Vagrant.require_version '>= 2.0.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  env_config.each do |server|
    config.vm.define server['name'] do |srv|
      # Configurações básicas da VM
      srv.vm.box      = server['box']
      srv.vm.hostname = server['hostname']
      srv.vm.network 'private_network', ip: server['ipaddress']

      # Interface adicional, se definida no YAML
      if server['additional_interface']
        srv.vm.network 'private_network', ip: '1.0.0.100', auto_config: false
      end

      # Configurações do provedor VirtualBox
      srv.vm.provider 'virtualbox' do |vb|
        vb.memory = server['memory']  # Memória da VM
        vb.cpus   = server['cpus']    # Número de CPUs
        # Nome da VM no VirtualBox
        vb.name = server['name']
        # Opções adicionais podem ser incluídas aqui
      end

      # Provisionamento via Shell Script
      srv.vm.provision "shell", inline: <<-SHELL
        # Atualizar a máquina
        apt-get update -y
        #apt-get upgrade -y

        sudo useradd -m -d /home/devops -s /bin/bash devops
        echo "devops ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/devops

        sudo apt remove --purge linux-image-5.4.0-42-generic -y || true
        sudo update-grub || true
        
        # Instalar Git e Ansible
        apt-get install -y git ansible

        # Clonar o repositório do Git
        git clone https://github.com/alissonoliveira0607/541-kubernetes.git /home/vagrant/kubernetes

        cat << EOF | sudo tee -a /etc/ansible/hosts
[local]
localhost
EOF

        # Navegar para o diretório do repositório
        cd /home/vagrant/kubernetes

        # Executar a playbook específica para esta máquina
        sudo ansible-playbook provision/ansible/#{server['provision']} -c local
      SHELL
    end
  end
end
