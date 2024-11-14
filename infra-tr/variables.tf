variable "student_id" {
  type    = string
  default = "101"  
}

variable "student_email" {
  type    = string
  default = "sarosamall@yahoo.com"  
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "name_prefix" {
  type    = string
  default = "fargate-basic"
}

variable "alarm_email" {
  type = string
  default = "sarosamall@yahoo.com"
}

variable "threshold" {
  default = 300
  type = number
}

variable "sqs_queue_name" {
  default = "image_processing_queue"
}
