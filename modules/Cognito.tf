//Create User Pool
resource "aws_cognito_user_pool" "pool" {
  name = "WildRydes-ddamia2"
}

//Add people to User pool
resource "aws_cognito_user_pool_client" "client" {
  name = "WildRydesWebApp-ddamia2"

  user_pool_id = aws_cognito_user_pool.pool.id
}