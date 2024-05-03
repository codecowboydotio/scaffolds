variable "default_ec2_tags" {
  description = "Default set of tags to apply to EC2 instances"
  type        = map
  default = {
    Owner       = "owner"
    Environment = "Demo"
    SupportTeam = "supportteam"
    Contact     = "me@my_email"
  }
}
