variable "aws_region" {
  type        = string
  description = "AWS region for deployment."
}

variable "glue_scripts_bucket_base_name" {
  type        = string
  description = "Base name for the Glue scripts S3 bucket."
}

variable "glue_output_bucket_base_name" {
  type        = string
  description = "Base name for the Glue output S3 bucket."
}

variable "glue_role_base_name" {
  type        = string
  description = "Base name for the Glue IAM role."
}

variable "glue_job_base_name" {
  type        = string
  description = "Base name for the Glue job."
}

variable "glue_job_base_name_2" {
  type        = string
  description = "Base name for the second Glue job."
}
