# dynamodb table        
resource "aws_dynamodb_table" "my_table"{
    name = "${var.my-env}-sidhi_bucket"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "id"
    attribute {
      name = "id"
      type = "S"
    }
}
  
