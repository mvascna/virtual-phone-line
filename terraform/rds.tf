resource aws_db_subnet_group vphone {
  name       = "vphone"
  subnet_ids = module.vpc.private_subnets
}

resource aws_db_instance vphone {
  identifier              = "vphone"
  db_subnet_group_name    = aws_db_subnet_group.vphone.name
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t2.micro"
  allocated_storage       = 20
  max_allocated_storage   = 100
  backup_retention_period = 7
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.vphone_rds.id]

  name     = "vphone"
  username = "vphone"
  password = "privatesubnetdontcareifleaked"
  port     = 3306
}

resource aws_security_group vphone_rds {
  vpc_id = module.vpc.vpc_id
  name   = "vphone-rds"
}

resource aws_security_group_rule vphone_rds_ingress_3306 {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.vphone_rds.id

  source_security_group_id = aws_security_group.cluster.id
}
