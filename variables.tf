variable "config" {
  description = "Azure monitor activity log alert configuration"
  type        = map(any)
}


variable "extra_tags" {
  description = "Additional tags to associate"
  type        = map(string)
  default     = {}
}
