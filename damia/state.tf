terraform {
  backend "s3" {
    bucket = "as-dma-sbx-tfstate"
    key    = "as-dma-sbx-tfstate/damia/terraform.tfstate"
    region = "us-east-2"
  }
}

