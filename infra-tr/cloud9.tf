resource "aws_cloud9_environment_ec2" "cloud_9_env" {
  name                        = "MyCloud9Env"
  instance_type               = "t3.micro"
  automatic_stop_time_minutes = 30
  image_id                    = "resolve:ssm:/aws/service/cloud9/amis/amazonlinux-2-x86_64"  
}
