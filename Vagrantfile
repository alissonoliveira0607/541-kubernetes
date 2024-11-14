VAGRANTFILE_API_VERSION = '2'

# Requerimento de módulos
require 'yaml'

# Carregando as configurações do ambiente a partir do arquivo YAML
env_config = YAML.load_file('environment.yaml')

# Especificando a versão mínima do Vagrant
Vagrant.require_version '>= 2.0.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Itera sobre as configurações de cada servidor definidas no YAML
  env_config.each do |server|
    config.vm.define server['name'] do |srv|
      # Configurações básicas da VM
      srv.vm.box      = server['box']
      srv.vm.hostname = server['hostname']
      srv.vm.network 'private_network', ip: server['ipaddress']

      # Configuração de interface adicional, se definida no YAML
      if server['additional_interface']
        srv.vm.network 'private_network', ip: '1.0.0.100', auto_config: false
      end

      # Configurações do provedor VirtualBox
      srv.vm.provider 'virtualbox' do |vb|
        vb.name   = server['name']
        vb.memory = server['memory']
        vb.cpus   = server['cpus']
      end

      # ===============================
      # Provisionamento via Shell Script
      # ===============================
      # Provisionamento de cada VM, com o Ansible instalado e o repositório clonado
      srv.vm.provision "shell", inline: <<-SHELL
        # Atualizar a máquina
        apt-get update -y
        apt-get upgrade -y

        sudo useradd -m -d /home/devops -s /bin/bash devops
        echo "devops ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/devops

        sudo apt remove --purge linux-image-5.4.0-42-generic -y
        sudo update-grub
        
        # Instalar Git e Ansible
        apt-get install -y git ansible

        # Clonar o repositório do Git
        git clone https://github.com/4linux/541-kubernetes.git /home/vagrant/kubernetes

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
