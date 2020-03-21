terraform {
  backend s3 {
    bucket         = "mvana-account-terraform"
    key            = "vphone"
    region         = "us-east-1"
    profile        = "mvana"
    dynamodb_table = "mvana-account-terraform"
  }
}

provider aws {
  region  = "us-east-1"
  profile = "mvana"
}
