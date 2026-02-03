provider "aws" {
  region = "us-west-2"
}

# Define a large number for the count to force many module instantiations
variable "num_buckets" {
  default = 900000000000 # A high number of iterations causes the slowdown
}

module "s3_buckets" {
  source = "./modules/simple_resource"
  count  = var.num_buckets

  bucket_name = "my-unique-bucket-name-${count.index}"
}

resource "aws_security_group" "my_security_group" {
  name_prefix = "example-sg-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  tags = {
    Name = "MyInstance"
  }
}

resource "azurerm_key_vault_secret" "secret_example_0" {
  name         = "secret_with_expiration_0"
  key_vault_id = azurerm_key_vault.example_key_vault.id
  value        = "secret_password_0"
}
