variable "dynamo_table_name" {

  type        = string
  default     = "sidhi-table"

  description = "this is table name for dynamodb"
}

variable "ec2_ami_id" {

  type    = string
  default = "ami-07a00cf47dbbc844c"
}