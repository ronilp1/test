provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "testvpcsecond" {
  cidr_block = "192.168.0.0/16"
}
