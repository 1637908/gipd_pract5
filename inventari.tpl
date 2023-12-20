[all:vars]
ansible_connection=ssh
ansible_user=adminp
ansible_ssh_pass=NebulaCaos
ansible_sudo_pass=NebulaCaos

[all]
%{for ip in vm_ips ~}
${ip}
%{endfor ~}
