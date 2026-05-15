#create ec2 instance 
module "dev-app"{
source = "./aws_infra"
my-env = "dev"
instance_type = "t3.small"
ami_id = "ami-07a00cf47dbbc844c"
instance_count = 1
}

module "staging-app"{
source = "./aws_infra"
my-env = "dev"
instance_type = "t3.small"
ami_id = "ami-07a00cf47dbbc844c"
instance_count = 2
}


module "prod-app"{
source = "./aws_infra"
my-env = "dev"
instance_type = "t3.small"
ami_id = "ami-07a00cf47dbbc844c"
instance_count = 3
}
