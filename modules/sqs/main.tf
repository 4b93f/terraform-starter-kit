resource "aws_sqs_queue" "my_sqs_queue" {
  name = var.queue_name
}