resource "aws_instance" "test-server" {
  ami = "ami-0dee22c13ea7a9a67"
  instance_type = "t2.micro"
  key_name = "docker"
  vpc_security_group_ids = ["sg-0fc8b1c023e7b4e38"]
   connection {
     type = "ssh"
     user = "ubuntu"
     private_key = file("./docker.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/Banking and Finance Domain Project/terraform-files/ansibleplaybook.yml"
     }
  }
