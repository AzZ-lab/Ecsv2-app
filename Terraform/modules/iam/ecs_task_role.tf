data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task" {
  name               = "${var.project_name}-${var.environment}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

data "aws_iam_policy_document" "ecs_task_dynamodb" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem"
    ]

    resources = [
      var.dynamodb_table_arn
    ]
  }
}

resource "aws_iam_role_policy" "ecs_task_dynamodb" {
  role   = aws_iam_role.ecs_task.id
  policy = data.aws_iam_policy_document.ecs_task_dynamodb.json
}
