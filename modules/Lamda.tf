data "archive_file" "lambda_zip" {                                                                                                                                                                                   
  type        = "zip"                                                                                                                                                                                                
  source_file  = "../modules/Files_lambda_S3/requestUnicorn.js"                                                                                                                                                                                         
  output_path = "../modules/Files_lambda_S3/lambda_package.zip"                                                                                                                                                                         
} 

resource "aws_lambda_function" "lambdafunc" {
  filename      = data.archive_file.lambda_zip.output_path
  //"../modules/Files_lambda_S3/requestUnicorn.js"
  function_name = var.lambda_name
  role          = aws_iam_role.wild_role.arn
  handler       = "lambda.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)

  runtime = "nodejs12.x"

  depends_on = [
    aws_iam_role_policy_attachment.AWSpolicy,
    aws_cloudwatch_log_group.log_group,
  ]

  tags = local.tags
}

