variable "default_ec2_tags" {
  description = "Default set of tags to apply to EC2 instances"
  type        = map
  default = {
    Owner       = "me"
    Environment = "Demo"
    SupportTeam = "support_team"
    Contact     = "me@example.com"
  }
}
