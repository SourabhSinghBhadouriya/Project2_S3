provider "aws" {

  region = "ap-south-1"
}

resource "aws_s3_bucket" "website_bucket" {

  bucket = "sourabh-project2-static-site-12345"
}
resource "aws_s3_bucket_public_access_block" "public" {

  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls = false

  block_public_policy = false

  ignore_public_acls = false

  restrict_public_buckets = false

}

resource "aws_s3_bucket_website_configuration" "website" {

  bucket = aws_s3_bucket.website_bucket.id


  index_document {

    suffix = "index.html"
  }

}

resource "aws_s3_bucket_policy" "public_policy" {

  bucket = aws_s3_bucket.website_bucket.id

  depends_on = [aws_s3_bucket_public_access_block.public]

  policy = jsonencode({
         Version = "2012-10-17"

    Statement = [

      {


        Sid = "PublicReadGetObject"

        Effect = "Allow"

        Principal = "*"

        Action = ["s3:GetObject"]

        Resource = "${aws_s3_bucket.website_bucket.arn}/*"
      }

    ]

  })

}

resource "aws_s3_object" "index" {

  bucket = aws_s3_bucket.website_bucket.id

  key = "index.html"

  source = "index.html"

  content_type = "text/html"

}

output "website_url" {

  value = "http://${aws_s3_bucket.website_bucket.bucket}.s3-website.${var.region}.amazonaws.com"

}
