/* data "template_file" "bucket_policy" {
  template = file("../modules/templates/policy_clientbucket.json")
  vars = {
    app_name  = var.app_name
    env       = var.env
  }
} */

resource "aws_s3_bucket" "static_site" {
  bucket = var.app_name
  acl    = "public-read"
  //policy = data.template_file.bucket_policy.rendered
  policy = templatefile("../modules/templates/policy_clientbucket.json",
  {
    app_name  = var.app_name
  })
  

  website {
    index_document = "index.html"
    error_document = "error.html"
    routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }

  tags = local.tags
}

output "url" {
    value = "${aws_s3_bucket.static_site.bucket}.s3-website-${var.region}.amazonaws.com"
  }

//Upload files to S3
//resource "aws_s3_bucket_object" "object" {
//  for_each = fileset("${path.module}/../clientSideFiles/", "**/*")
  //fileset(path.module, "../clientSideFiles/**/*")


//  bucket = aws_s3_bucket.static_site.bucket
//  key    = each.value
//  source = "${path.module}/../clientSideFiles/${each.value}"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
//  etag = "${filemd5("${path.module}/../clientSideFiles/${each.value}")}"

//}

//output "fileset-results" {
//  value = fileset("${path.module}/../clientSideFiles/","**/*")
  //(path.module,"../clientSideFiles/**/*")
//}

resource "aws_s3_bucket_public_access_block" "access" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls = true
  ignore_public_acls = true
  block_public_policy = false
  restrict_public_buckets = false
}