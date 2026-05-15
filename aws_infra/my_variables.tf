variable "my-env"{
    description = "this is env for infra"
    type= string 

}

variable "ami_id"{
 description = "ami_id for ec2"
 type = string
}

variable "instance_type"{
 description = "this is the instance for ec2"
 type = string
}

variable "instance_count"{
 description = "this is for no. of instance"
 type = number
}
  