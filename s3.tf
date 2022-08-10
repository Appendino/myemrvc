# Create a bucket
resource "aws_s3_bucket" "b1" {
  bucket = "my-secrets-buckets-666"
  acl    = "private"   # or can be "public-read"
  tags = {
    Name        = "BucketSecrets"
    Environment = "Dev"
  }
}

# Upload an object
resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.b1.id
  key    = "eks-mlops/cert_files.zip"
  acl    = "private"
  source = "certs/cert_files.zip"
  etag = filemd5("certs/cert_files.zip")
}

