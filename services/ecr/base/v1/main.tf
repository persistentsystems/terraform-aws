
locals {
    repository_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "ReadonlyAccess",
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:DescribeImageScanFindings",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories",
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:ListImages"
        ],
        "Effect": "Allow",
        "Principal": {"AWS": [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        ]}
      }
    ]
  }
POLICY
}

data "aws_caller_identity" "current" {}

resource "aws_ecr_repository" "ecr" {
  name = var.ecr_settings.repository_name
  image_tag_mutability = var.ecr_settings.tag_mutability

  image_scanning_configuration {
    scan_on_push = var.ecr_settings.scan_on_push
  }

  tags = merge(
    {
      Name = "${var.context.app_name}_ecr_repo",
      Environment = var.context.env_name
      Location = var.context.location
    },
    var.ecr_settings.custom_tags
  )
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  count = var.ecr_settings.attach_lifecycle_policy ? 1 : 0

  repository = aws_ecr_repository.ecr.name
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 10 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": ${var.ecr_settings.untagged_days}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

resource "aws_ecr_repository_policy" "repo_policy" {
  repository = aws_ecr_repository.ecr.name

  policy = fileexists("${path.module}/policy.json") ? file("${path.module}/policy.json") : local.repository_policy

}
