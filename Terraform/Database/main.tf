provider "aws" {
  region = "us-east-1"
}

# Remote State sends on S3 Bucket
terraform {
  backend "s3" {
    bucket  = "dribbledata-project-remote-state"
    key     = "Database/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

resource "aws_dynamodb_table" "users" {
  name           = "Users"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  hash_key = "UserID"

  attribute {
    name = "UserID"
    type = "S"
  }
}

resource "aws_dynamodb_table" "players" {
  name           = "Players"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  hash_key = "PlayerID"

  attribute {
    name = "PlayerID"
    type = "S"
  }
}

resource "aws_dynamodb_table" "messages" {
  name           = "Messages"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  hash_key = "MessageID"

  attribute {
    name = "MessageID"
    type = "S"
  }
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_dynamodb_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# IAM Policy for Lambda
resource "aws_iam_policy" "lambda_policy" {
  name = "lambda_dynamodb_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:Scan",
          "dynamodb:DeleteItem"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/Messages"
      }
    ]
  })
}

# Attach IAM Policy to Role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Lambda Function
resource "aws_lambda_function" "delete_old_messages" {
  filename      = "archive_chat_function.zip"
  function_name = "delete_old_messages"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  source_code_hash = filebase64sha256("archive_chat_function.zip")
}

# EventBridge Rule
resource "aws_cloudwatch_event_rule" "every_24_hours" {
  name                = "every_24_hours"
  description         = "Trigger Lambda every 24 hours"
  schedule_expression = "rate(24 hours)"
}

# EventBridge Target
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.every_24_hours.name
  target_id = "lambda"
  arn       = aws_lambda_function.delete_old_messages.arn
}

# Lambda Permission for EventBridge
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_old_messages.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_24_hours.arn
}

/* # Lambda For Every 5 minutes
# EventBridge Rule
resource "aws_cloudwatch_event_rule" "every_5_minutes" {
  name                = "every_5_minutes"
  description         = "Trigger Lambda every 5 minutes"
  schedule_expression = "rate(5 minutes)"
}

# EventBridge Target
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.every_5_minutes.name
  target_id = "lambda"
  arn       = aws_lambda_function.delete_old_messages.arn
}

# Lambda Permission for EventBridge
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_old_messages.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_5_minutes.arn
}
*/
