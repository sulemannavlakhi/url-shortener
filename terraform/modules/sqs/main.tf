# any messages that fail processing get moved here after max attempts

resource "aws_sqs_queue" "dlq" {
  name                      = "${var.project_name}-${var.environment}-click-events-dlq"
  message_retention_seconds = 1209600
}