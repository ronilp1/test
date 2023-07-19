provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "testvpcsecond" {
  cidr_block = "10.1.0.0/16"
}
