//Create table called Rides-ddamia2 with 1 field
resource "aws_dynamodb_table" "Rides" {
  name           = "Rides-ddamia2"
  hash_key       = "RideId"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "RideId"
    type = "S"
  }

    tags = local.tags

}