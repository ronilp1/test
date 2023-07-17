provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0b94777c7d8bfe7e3"
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }
}
