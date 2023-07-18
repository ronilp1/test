provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0b94777c7d8bfe7e3"
  instance_type = "t2.micro"

  subnet_id = "subnet-05f0d66db2a906ed9" # <--- Add this line. Replace "your-subnet-id" with your actual subnet ID.

  tags = {
    Name = "example-instance"
  }
}
