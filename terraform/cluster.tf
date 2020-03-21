# Compute
resource aws_ecs_cluster cluster {
  name = "vphone"
}

resource aws_autoscaling_group cluster {
  name                 = aws_ecs_cluster.cluster.name
  vpc_zone_identifier  = module.vpc.private_subnets
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.cluster.name

  tags = [
    {
      key                 = "Name"
      value               = "vphone"
      propagate_at_launch = true
    }
  ]
}

data aws_ami cluster {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami*amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

data template_file user_data {
  template = file("${path.module}/templates/user-data.sh")

  vars = {
    ecs_config        = "echo '' > /etc/ecs/ecs.config"
    ecs_logging       = "[\"json-file\",\"awslogs\"]"
    cluster_name      = aws_ecs_cluster.cluster.name
    cloudwatch_prefix = "vphone"
  }
}

resource aws_launch_configuration cluster {
  security_groups             = [aws_security_group.cluster.id]
  image_id                    = data.aws_ami.cluster.id
  instance_type               = "t3.micro"
  iam_instance_profile        = aws_iam_instance_profile.cluster.name
  associate_public_ip_address = false

  user_data = data.template_file.user_data.rendered

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [image_id]
  }
}

# Security Groups
resource aws_security_group cluster {
  vpc_id = module.vpc.vpc_id
  name   = "vphone-cluster"
}

resource aws_security_group_rule cluster_ingress {
  type              = "ingress"
  from_port         = 32768
  to_port           = 61000
  protocol          = "tcp"
  security_group_id = aws_security_group.cluster.id

  source_security_group_id = aws_security_group.load_balancer.id
}

resource aws_security_group_rule cluster_egress {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.cluster.id

  cidr_blocks = ["0.0.0.0/0"]
}

# IAM
data aws_iam_policy_document ec2_assume_role_policy {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource aws_iam_role cluster_instance {
  name               = aws_ecs_cluster.cluster.name
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
}

resource aws_iam_role_policy_attachment attach_ecs_policy {
  role       = aws_iam_role.cluster_instance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource aws_iam_role_policy_attachment attach_ecr_policy {
  role       = aws_iam_role.cluster_instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource aws_iam_role_policy_attachment attach_ssm_policy {
  role       = aws_iam_role.cluster_instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data aws_iam_policy_document allow_logging_policy {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents", "logs:DescribeLogStreams"]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource aws_iam_role_policy allow_logging_policy {
  name   = aws_iam_role.cluster_instance.name
  role   = aws_iam_role.cluster_instance.name
  policy = data.aws_iam_policy_document.allow_logging_policy.json
}

resource aws_iam_instance_profile cluster {
  name = aws_ecs_cluster.cluster.name
  role = aws_iam_role.cluster_instance.name
}
