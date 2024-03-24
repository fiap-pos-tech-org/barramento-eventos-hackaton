provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "fiap-pos-hackaton"
    key    = "events/events.tfstate"
    region = "us-east-1"
  }

  required_version = ">= 1.6.1"
}
