variable "topic_name" {
  type = string
}

variable "email_subscriptions" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
