
# ─────────────────────────────────────────────────────────────────────────────
# Remote backend — state stored in S3, locking via DynamoDB
# (Provisioned by the bootstrap/ folder)
# ─────────────────────────────────────────────────────────────────────────────
terraform {
  backend "s3" {
    bucket         = "tfstate-test-count-m949nqzv"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tflock-test-count-m949nqzv"
    encrypt        = true
  }
}

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_region" "current" {}

resource "random_string" "suffix" {
  length  = 18
  upper   = false
  special = false
}

resource "aws_s3_bucket" "glue_scripts" {
  bucket = "${var.glue_scripts_bucket_base_name}-${random_string.suffix.result}"
}

resource "aws_s3_bucket" "glue_output" {
  bucket = "${var.glue_output_bucket_base_name}-${random_string.suffix.result}"
}

resource "local_file" "glue_test_script" {
  filename = "${path.module}/glue_test_script.py"
  content  = <<-EOF
print("Hello from TEST script")
EOF
}

resource "aws_s3_object" "glue_test_script" {
  bucket       = aws_s3_bucket.glue_scripts.id
  key          = "scripts/glue_test_script.py"
  source       = local_file.glue_test_script.filename
  content_type = "text/x-python"
}

resource "aws_iam_role" "glue" {
  name = "${var.glue_role_base_name}-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glue_service" {
  role       = aws_iam_role.glue.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy_attachment" "glue_admin" {
  role       = aws_iam_role.glue.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_glue_job" "count_job" {
  name              = "${var.glue_job_base_name}-${random_string.suffix.result}"
  role_arn          = aws_iam_role.glue.arn
  glue_version      = "5.0"
  max_retries       = 0
  timeout           = 2880
  number_of_workers = 2
  worker_type       = "G.1X"

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.glue_scripts.bucket}/${aws_s3_object.glue_test_script.key}"
    python_version  = "3"
  }

  default_arguments = {
    "--job-language"                     = "python"
    "--enable-metrics"                   = ""
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--TempDir"                          = "s3://${aws_s3_bucket.glue_output.bucket}/temp/"
    "--output_bucket"                    = aws_s3_bucket.glue_output.bucket
    "--input_range_start"                = "1"
    "--input_range_end"                  = "20"
  }

  execution_property {
    max_concurrent_runs = 1
  }

  depends_on = [
    aws_s3_object.glue_test_script,
    aws_iam_role_policy_attachment.glue_service,
    aws_iam_role_policy_attachment.glue_admin
  ]
}
