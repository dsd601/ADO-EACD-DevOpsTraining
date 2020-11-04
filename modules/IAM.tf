//Create Role for AWS Service - Lamda
resource "aws_iam_role" "wild_role" {
  name = "WildRydesLambda-ddamia2"

  //Create AWS Managed policy and IAM role inline policy
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [

    {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "dynamodb.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      },
    {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "apigateway.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
  EOF

  tags = local.tags
}

//Attach 2 Policies to the above role
//Add AWS Managed policy
resource "aws_iam_policy" "policy" {
  name        = "wild-policy"
  description = "A test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "lambda:InvokeFunction"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSpolicy" {
  policy_arn = aws_iam_policy.policy.arn
  //"arn:aws:iam::aws:policy/AWSLamdaBasicExecutionRole"
  role       = aws_iam_role.wild_role.name
}

//Create IAM role inline policy (Write access to only 1 table)
resource "aws_iam_role_policy" "inline_policy" {
  name = "DynamoDBWriteAccess"
  role = aws_iam_role.wild_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "DynamoDB:PutItem"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}