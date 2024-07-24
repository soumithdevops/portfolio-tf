resource "aws_s3_bucket" "newbucket" {
  bucket = var.bucket
}

resource "aws_s3_bucket_website_configuration" "websiteconf" {
  bucket = aws_s3_bucket.newbucket.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
  depends_on = [ aws_s3_bucket_acl.policy ]
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.newbucket.id
  key    = "index.html"
  source = "index.html"
  content_type = "text/html"
  acl = "public-read"
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.newbucket.id
  key    = "error.html"
  source = "error.html"
  content_type = "text/html"
  acl = "public-read"
}

resource "aws_s3_object" "photo" {
  bucket = aws_s3_bucket.newbucket.id
  key    = "soumith_photo"
  source = "soumith_passport.JPG"
  acl = "public-read"
}

resource "aws_s3_bucket_ownership_controls" "bucketownership" {
  bucket = aws_s3_bucket.newbucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "publicpermission" {
  bucket = aws_s3_bucket.newbucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "policy" {
  depends_on = [
    aws_s3_bucket_ownership_controls.bucketownership,
    aws_s3_bucket_public_access_block.publicpermission,
  ]

  bucket = aws_s3_bucket.newbucket.id
  acl    = "public-read"
}

output "bucketname" {
  value = aws_s3_bucket.newbucket.bucket
}

