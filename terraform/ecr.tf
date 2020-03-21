resource aws_ecr_repository vphone {
  name = "vphone"

  image_scanning_configuration {
    scan_on_push = true
  }
}
