variable "ssh_private_key_path" {
  description = "Path to the SSH private key used by Ansible (use forward slashes on Windows)."
  type        = string

  validation {
    condition     = can(regex("\\.pem$", lower(var.ssh_private_key_path)))
    error_message = "ssh_private_key_path must point to a .pem private key file, for example C:/Users/Dineth/Downloads/cicd.pem."
  }
}

variable "ansible_ssh_user" {
  description = "SSH username for Ansible connection."
  type        = string
  default     = "ubuntu"
}

locals {
  module_windows_path = replace(abspath(path.module), "\\", "/")
  module_wsl_path     = "/mnt/${lower(substr(local.module_windows_path, 0, 1))}/${substr(local.module_windows_path, 3, length(local.module_windows_path) - 3)}"

  key_windows_path = replace(var.ssh_private_key_path, "\\", "/")
  key_wsl_path     = "/mnt/${lower(substr(local.key_windows_path, 0, 1))}/${substr(local.key_windows_path, 3, length(local.key_windows_path) - 3)}"
}

resource "aws_instance" "Public_ec2-1" {
  ami                         = "ami-05d2d839d4f73aafb"
  instance_type               = "t3.small"
  associate_public_ip_address = true
  key_name                    = "cicd"

  subnet_id                   = aws_subnet.public12.id
  vpc_security_group_ids      = [aws_security_group.Public_ec2_sg.id]



  user_data_replace_on_change = true


  tags = {
    Name = "public-ec2"
  }
}

resource "aws_eip" "public_ec2_eip" {
  domain = "vpc"

  tags = {
    Name = "public-ec2-eip"
  }
}

resource "aws_eip_association" "public_ec2_eip_assoc" {
  instance_id   = aws_instance.Public_ec2-1.id
  allocation_id = aws_eip.public_ec2_eip.id

  provisioner "local-exec" {
    interpreter = ["wsl", "--cd", "~", "bash", "-lc"]
    command     = "set -e; mkdir -p ~/.ssh; cp '${local.key_wsl_path}' ~/.ssh/terraform_cicd.pem; chmod 600 ~/.ssh/terraform_cicd.pem; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${aws_eip.public_ec2_eip.public_ip},' -u '${var.ansible_ssh_user}' --private-key ~/.ssh/terraform_cicd.pem '${local.module_wsl_path}/ansible/install-docker.yml'"
  }
}


resource "aws_security_group" "Public_ec2_sg" {
    name        = "Ec2_SG"
    vpc_id      = aws_vpc.main.id
    
    tags = {
        Name = "EC2-SG"
    }
    ingress {
        description = "HTTP from Load Balancer"
        from_port   = 5000
        to_port     = 5000
        protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }


    ingress {
      description = "SSH from Bastion"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

}





