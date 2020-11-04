// Create API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name = "WildRydes-ddamia2"
  description = "API for Wild Rydes with Terraform"
}

// Create Cognito User Pools Authorizer
data "aws_cognito_user_pools" "users" {
  depends_on = [aws_cognito_user_pool.pool]
  name = aws_cognito_user_pool.pool.name
}

resource "aws_api_gateway_authorizer" "auth" {
  name                   = "WildRydes-ddamia2"
  rest_api_id            = aws_api_gateway_rest_api.api.id
  authorizer_uri         = aws_lambda_function.lambdafunc.invoke_arn
  authorizer_credentials = aws_iam_role.wild_role.arn
  type                   = "COGNITO_USER_POOLS"
  provider_arns          = data.aws_cognito_user_pools.users.arns
}

//Create API Resource and Method
resource "aws_api_gateway_resource" "ride" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "ride"
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.ride.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.auth.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

//Lamda Integration
resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.ride.id
  http_method             = aws_api_gateway_method.api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambdafunc.invoke_arn
}

//Deploy API
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [aws_api_gateway_integration.integration]

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "damia"

  variables = {
    "answer" = "42"
  }

}