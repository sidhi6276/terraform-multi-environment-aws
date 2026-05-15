resource "aws_s3_bucket" "my-bucket" {
    #agrs
    bucket = "bucket-sidhi"
    tags = {
        name="bucket-sidhi"
    }
}