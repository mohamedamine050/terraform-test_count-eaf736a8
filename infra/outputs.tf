output "aws_region" {
  value = data.aws_region.current.name
}

output "random_suffix" {
  value = random_string.suffix.result
}

output "glue_scripts_bucket_name" {
  value = aws_s3_bucket.glue_scripts.id
}

output "glue_scripts_bucket_arn" {
  value = aws_s3_bucket.glue_scripts.arn
}

output "glue_scripts_bucket_domain_name" {
  value = aws_s3_bucket.glue_scripts.bucket_domain_name
}

output "glue_scripts_bucket_regional_domain_name" {
  value = aws_s3_bucket.glue_scripts.bucket_regional_domain_name
}

output "glue_scripts_bucket_region" {
  value = data.aws_region.current.name
}

output "glue_output_bucket_name" {
  value = aws_s3_bucket.glue_output.id
}

output "glue_output_bucket_arn" {
  value = aws_s3_bucket.glue_output.arn
}

output "glue_output_bucket_domain_name" {
  value = aws_s3_bucket.glue_output.bucket_domain_name
}

output "glue_output_bucket_regional_domain_name" {
  value = aws_s3_bucket.glue_output.bucket_regional_domain_name
}

output "glue_output_bucket_region" {
  value = data.aws_region.current.name
}

output "glue_test_script_s3_uri" {
  value = "s3://${aws_s3_bucket.glue_scripts.bucket}/${aws_s3_object.glue_test_script.key}"
}

output "glue_test_script_arn" {
  value = aws_s3_object.glue_test_script.arn
}

output "glue_test_script_etag" {
  value     = aws_s3_object.glue_test_script.etag
  sensitive = true
}

output "glue_test_script_2_s3_uri" {
  value = "s3://${aws_s3_bucket.glue_output.bucket}/${aws_s3_object.glue_test_script_2.key}"
}

output "glue_test_script_2_arn" {
  value = aws_s3_object.glue_test_script_2.arn
}

output "glue_test_script_2_etag" {
  value     = aws_s3_object.glue_test_script_2.etag
  sensitive = true
}

output "glue_role_name" {
  value = aws_iam_role.glue.name
}

output "glue_role_arn" {
  value = aws_iam_role.glue.arn
}

output "glue_role_unique_id" {
  value = aws_iam_role.glue.unique_id
}

output "glue_job_name" {
  value = aws_glue_job.count_job.id
}

output "glue_job_arn" {
  value = aws_glue_job.count_job.arn
}

output "glue_job_2_name" {
  value = aws_glue_job.count_job_2.id
}

output "glue_job_2_arn" {
  value = aws_glue_job.count_job_2.arn
}
