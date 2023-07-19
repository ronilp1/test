provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "testvpc" {
  cidr_block = "10.3.0.0/16"
}
