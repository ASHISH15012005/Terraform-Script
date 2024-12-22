# aws security group 
resource "aws_security_group" "Project-SG" {
    name = "Project-SG"
    description =  "Open for 22,443,80,8080,9000"
#8080 - jenkins
#9000 - sonarqube
# Define a single ingress rule to allow traffic on all specified ports
# Ingress rules are like firewalls which controls incoming traffic

ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

tags =  {
    Name = "Project-SG"
}
}

resource "aws_instance" "web"{
    ami = ami-0fd05997b4dff7aac
    instance_type = "t2.large"
    key_name = "Ashish"
    vpc_security_group_ids = [aws_security_group.Project-SG.id]
    user_data = templatefile("./resource.sh", {})
    
    tags = {
    Name = "Ashish"
  }
root_block_device {
  volume_size = 30
}
}