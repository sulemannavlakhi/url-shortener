# any messages that fail processing get moved here after max attempts

resource "aws_sqs_queue" "dlq" {
  name                      = "${var.project_name}-${var.environment}-click-events-dlq"
  message_retention_seconds = 1209600
}

# main queue the api publishes click events to, worker polls from this
# long polling enabled via receive_wait_time_seconds to reduce empty receives
resource "aws_sqs_queue" "main" {
  name                       = "${var.project_name}-${var.environment}-click-events"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 20

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 5
  })
}
