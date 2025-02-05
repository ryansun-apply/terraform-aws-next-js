####################
# Image Optimization
####################

variable "create_image_optimization" {
  description = "Controls whether resources for image optimization support should be created or not."
  type        = bool
  default     = true
}

variable "image_optimization_lambda_memory_size" {
  description = "Amount of memory in MB the worker Lambda Function for image optimization can use. Valid value between 128 MB to 10,240 MB, in 1 MB increments."
  type        = number
  default     = 2048
}

######################
# Multiple deployments
######################

variable "enable_multiple_deployments" {
  description = "Controls whether it should be possible to run multiple deployments in parallel (requires multiple_deployments_base_domain)."
  type        = bool
  default     = false
}

variable "multiple_deployments_base_domain" {
  description = "Default wildcard domain where new deployments should be available. Should be in the form of *.example.com."
  type        = string
  default     = null
}

###################
# Lambdas (Next.js)
###################

variable "lambda_policy_json" {
  description = "Additional policy document as JSON to attach to the Lambda Function role"
  type        = string
  default     = null
}

variable "lambda_attach_policy_json" {
  description = "Whether to deploy additional lambda JSON policies. If false, lambda_policy_json will not be attached to the lambda function. (Necessary since policy strings are only known after apply when using Terraforms data.aws_iam_policy_document)"
  type        = bool
  default     = false
}

variable "lambda_role_permissions_boundary" {
  type = string
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_boundaries.html
  description = "ARN of IAM policy that scopes aws_iam_role access for the lambda"
  default     = null
}

variable "lambda_attach_to_vpc" {
  type        = bool
  description = "Set to true if the Lambda functions should be attached to a VPC. Use this setting if VPC resources should be accessed by the Lambda functions. When setting this to true, use vpc_security_group_ids and vpc_subnet_ids to specify the VPC networking. Note that attaching to a VPC would introduce a delay on to cold starts"
  default     = false
}

variable "vpc_subnet_ids" {
  type        = list(string)
  description = "The list of VPC subnet IDs to attach the Lambda functions. lambda_attach_to_vpc should be set to true for these to be applied."
  default     = []
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "The list of Security Group IDs to be used by the Lambda functions. lambda_attach_to_vpc should be set to true for these to be applied."
  default     = []
}

#########################
# Cloudfront Distribution
#########################
variable "cloudfront_create_distribution" {
  description = "Controls whether the main CloudFront distribution should be created."
  type        = bool
  default     = true
}

variable "cloudfront_price_class" {
  description = "Price class for the CloudFront distributions (main & proxy config). One of PriceClass_All, PriceClass_200, PriceClass_100."
  type        = string
  default     = "PriceClass_100"
}

variable "cloudfront_aliases" {
  description = "Aliases for custom_domain"
  type        = list(string)
  default     = []
}

variable "cloudfront_acm_certificate_arn" {
  description = "ACM certificate arn for custom_domain"
  type        = string
  default     = null
}

variable "cloudfront_minimum_protocol_version" {
  description = "The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. One of SSLv3, TLSv1, TLSv1_2016, TLSv1.1_2016, TLSv1.2_2018 or TLSv1.2_2019."
  type        = string
  default     = "TLSv1"
}
variable "cloudfront_response_headers_policy" {
  description = "Id of a response headers policy. Can be custom or managed. Default is empty."
  type        = string
  default     = null
}

variable "cloudfront_cache_key_headers" {
  description = "Header keys that should be used to calculate the cache key in CloudFront."
  type        = list(string)
  default     = ["Authorization"]
}
variable "cloudfront_origin_request_policy_name" {
  description = "Id of a custom request policy that overrides the default policy (AllViewer). Can be custom or managed."
  type        = string
  default     = null
}
variable "cloudfront_cache_policy_name" {
  description = "Id of a custom cache policy that overrides creation."
  type        = string
  default     = null
}
variable "cloudfront_opt_origin_request_policy_name" {
  type        = string
  description = "Name of Origin request to apply for Image Optmizer CF"
  default     = null
}
variable "cloudfront_opt_cache_policy_name" {
  type        = string
  description = "Name of Cache policy to apply for Image Optmizer CF"
  default     = null
}
variable "cloudfront_external_id" {
  description = "When using an external CloudFront distribution provide its id."
  type        = string
  default     = null
}

variable "cloudfront_external_arn" {
  description = "When using an external CloudFront distribution provide its arn."
  type        = string
  default     = null
}

variable "cloudfront_webacl_id" {
  description = "An optional webacl2 arn or webacl id to associate with the cloudfront distribution"
  type        = string
  default     = null
}

##########
# Labeling
##########
variable "deployment_name" {
  description = "Identifier for the deployment group (only lowercase alphanumeric characters and hyphens are allowed)."
  type        = string
  default     = "tf-next"

  validation {
    condition     = can(regex("[a-z0-9-]+", var.deployment_name))
    error_message = "Only lowercase alphanumeric characters and hyphens allowed."
  }
}

variable "tags" {
  description = "Tag metadata to label AWS resources that support tags."
  type        = map(string)
  default     = {}
}

variable "tags_s3_bucket" {
  description = "Tag metadata to label AWS S3 buckets. Overrides tags with the same name in input variable tags."
  type        = map(string)
  default     = {}
}

################
# Debug Settings
################
variable "debug_use_local_packages" {
  description = "Use locally built packages rather than download them from npm."
  type        = bool
  default     = false
}
