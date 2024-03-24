data "aws_iam_policy_document" "iam_sqs_send_policy" {
  statement {
    sid    = "send_message"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["sqs:SendMessage"]
    resources = ["arn:aws:sqs:us-east-1:720502424322:*"]
  }
}

resource "aws_sqs_queue" "registry_queue" {
  name          = var.registry_queue
  delay_seconds = 60
  policy        = data.aws_iam_policy_document.iam_sqs_send_policy.json

  tags = {
    Environment = "hackaton"
    Engine      = "terraform"
  }
}

resource "aws_sqs_queue" "report_queue" {
  name          = var.report_queue
  delay_seconds = 60
  policy        = data.aws_iam_policy_document.iam_sqs_send_policy.json

  tags = {
    Environment = "hackaton"
    Engine      = "terraform"
  }
}

resource "aws_sns_topic" "registry_topic" {
  name = var.registry_topic

  tags = {
    Environment = "hackaton"
    Engine      = "terraform"
  }
}

resource "aws_sns_topic" "report_notification_topic" {
  name = var.report_notification_topic

  tags = {
    Environment = "hackaton"
    Engine      = "terraform"
  }
}


resource "aws_sns_topic_subscription" "registry_topic_report_queue" {
  topic_arn = aws_sns_topic.registry_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.report_queue.arn

  filter_policy = <<POLICY
  {
    "yearMonth": [{"exists": true}]
  }
  POLICY

  filter_policy_scope = "MessageBody"

  depends_on = [
    aws_sns_topic.registry_topic,
    aws_sqs_queue.report_queue
  ]
}

resource "aws_sns_topic_subscription" "registry_topic_registry_queue" {
  topic_arn = aws_sns_topic.registry_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.registry_queue.arn

  filter_policy = <<POLICY
  {
    "timeClockId": [{"exists": true}]
  }
  POLICY

  filter_policy_scope = "MessageBody"

  depends_on = [
    aws_sns_topic.registry_topic,
    aws_sqs_queue.registry_queue
  ]
}
