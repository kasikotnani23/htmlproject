provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "server-1" {
  ami             = "ami-04b4f1a9cf54c11d0"
  instance_type   = "t2.micro"
  key_name        = "Ubuntu_key"
  subnet_id       = "subnet-07b3d29cb6c7958c7"
  security_groups = ["sg-078066b38c1857ea4"]

  tags = {
    Name = "terraform-server-1"
  }
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install default-jdk -y

    # Add Jenkins repo and install
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt update -y
    sudo apt install jenkins -y

    # Enable & start Jenkins
    sudo systemctl enable --now jenkins

    # Wait and check Jenkins status
    sleep 10
    sudo systemctl status jenkins
    sudo apt update -y
    sudo apt install maven -y
    sudo apt update 
    sudo apt install docker.io -y
    docker run --name con-1 -d -p 8088:80 nginx
    EOF
}
output "public_ip" {
  value       = aws_instance.server-1.public_ip
  description = "Public IP of the Jenkins Server"
} 
