provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_sns_topic" "example" {
  name         = "example"
  display_name = "Example Topic"
}
