output "DynamoDB_Table_Users_ARN" {
  description = "DynamoDB Table Users"
  value       = aws_dynamodb_table.users.arn
}

output "DynamoDB_Table_Players_ARN" {
  description = "DynamoDB Table Players"
  value       = aws_dynamodb_table.players.arn
}

output "DynamoDB_Table_Messages_ARN" {
  description = "DynamoDB Table Users"
  value       = aws_dynamodb_table.messages.arn
}

