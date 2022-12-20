resource "aws_s3_bucket" "bucket" {
  bucket = "jira-task-bucket"
}

resource "aws_s3_bucket_acl" "acl_bucket" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

resource "aws_cloudfront_distribution" "my_distribution" {
  origin {
    domain_name = aws_s3_bucket.bucket.bucket_domain_name
    origin_id   = "my-origin"
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "my-origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  enabled = true

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "Production"
  }
}