# Configure the AWS Provider
provider "aws" {}

# Edxapp server
resource "aws_instance" "edxapp" {
	associate_public_ip_address = False,
	
  }
