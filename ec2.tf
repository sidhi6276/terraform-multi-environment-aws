#key-pair
resource "aws_key_pair" "key_pair" {

  key_name   = "terra-key"
  public_key = file("C:/Users/Welcome/Desktop/terraform-practice/terra-key.pub")
}

#default-vpc
resource "aws_default_vpc" "default_vpc"{

}

#security_group
resource "aws_security_group" "security_group"{
     name = "allow ports"
     description = "this security grp open ports for ec2 instance"
     vpc_id = aws_default_vpc.default_vpc.id
 
  #interpolation : kisi bhi resource ko access ker skte hai
     #incoming traffic

     ingress{
        description = "this is for ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
     }

     ingress{
        description = "http"
        to_port = 80
        from_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
     #outgoing
     egress{
        description = "this is for outgoing traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
     }
}

#ec2-instanceaction 
  resource "aws_instance" "ec2_nstance"{
   ami=var.ec2_ami_id
   instance_type = "t3.small"
   key_name=aws_key_pair.key_pair.key_name
   vpc_security_group_ids = [aws_security_group.security_group.id]
   tags={
    name = "sidhi-ec2-automate"
   }
  }
