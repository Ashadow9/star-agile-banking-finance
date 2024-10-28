resource "aws_instance" "test-server" {
  ami                    = "ami-0dee22c13ea7a9a67"
  instance_type         = "t2.micro"
  key_name               = "docker"
  vpc_security_group_ids = ["sg-0fc8b1c023e7b4e38"]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./docker.pem")
    host        = self.public_ip
  }

  # Provisioner to run commands on the instance
  provisioner "remote-exec" {
    inline = [
      "echo 'waiting for the instance to start...'",
      "sleep 30"  # Wait for a while to ensure services are up
    ]
  }

  # Provisioner to create an inventory file for Ansible
  provisioner "local-exec" {
    command = "echo ${self.public_ip} > inventory"
  }

  # Provisioner to run the Ansible playbook
  provisioner "local-exec" {
    command = "ansible-playbook '/var/lib/jenkins/workspace/Banking and Finance Domain Project/terraform-files/ansibleplaybook.yml'"
  }

  tags = {
    Name = "test-server"
  }
}
