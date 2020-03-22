resource aws_ecs_service vphone {
  name            = "vphone"
  cluster         = aws_ecs_cluster.cluster.id
  desired_count   = 1
  iam_role        = aws_iam_role.vphone_ecs_service.name
  task_definition = aws_ecs_task_definition.vphone.arn

  deployment_minimum_healthy_percent = 0

  load_balancer {
    target_group_arn = aws_lb_target_group.vphone.id
    container_name   = "vphone"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.load_balancer_https]
}

data aws_iam_policy_document vphone_ecs_assume_role_policy {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource aws_iam_role vphone_ecs_service {
  name               = "vphone-ecs"
  assume_role_policy = data.aws_iam_policy_document.vphone_ecs_assume_role_policy.json
}

data aws_iam_policy_document vphone_ecs_service_lb {
  statement {
    effect = "Allow"
    actions = [
      "ec2:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets"
    ]
    resources = ["*"]
  }
}

resource aws_iam_role_policy vphone_ecs_service_lb {
  name   = aws_iam_role.vphone_ecs_service.name
  role   = aws_iam_role.vphone_ecs_service.name
  policy = data.aws_iam_policy_document.vphone_ecs_service_lb.json
}

resource aws_ecs_task_definition vphone {
  family = "vphone"

  container_definitions = <<EOF
[
  {
    "volumesFrom": [],
    "extraHosts": null,
    "dnsServers": null,
    "disableNetworking": null,
    "dnsSearchDomains": null,
    "portMappings": [
      {
        "hostPort": 0,
        "containerPort": 80,
        "protocol": "tcp"
      }
    ],
    "hostname": null,
    "essential": true,
    "entryPoint": null,
    "mountPoints": [],
    "name": "vphone",
    "ulimits": null,
    "dockerSecurityOptions": null,
    "environment": [
      {
        "name": "MYSQL_HOST",
        "value": "${aws_db_instance.vphone.address}"
      },
      {
        "name": "MYSQL_DATABASE",
        "value": "${aws_db_instance.vphone.name}"
      },
      {
        "name": "MYSQL_USER",
        "value": "${aws_db_instance.vphone.username}"
      },
      {
        "name": "MYSQL_PASSWORD",
        "value": "${aws_db_instance.vphone.password}"
      },
      {
        "name": "TITLE",
        "value": "Welcome to the Virtual Meeting Finder, provided by the North Star Group of Narcotics Anonymous"
      },
      {
        "name": "BMLT_ROOT_SERVER",
        "value": "https://bmlt.virtual-na.org/main_server"
      },
      {
        "name": "GOOGLE_MAPS_API_KEY",
        "value": "${var.google_maps_api_key}"
      },
      {
        "name": "TWILIO_ACCOUNT_SID",
        "value": "${var.twilio_account_sid}"
      },
      {
        "name": "TWILIO_AUTH_TOKEN",
        "value": "${var.twilio_auth_token}"
      },
      {
        "name": "CUSTOM_QUERY",
        "value": "&weekdays={DAY}&formats=47&sort_keys=start_time"
      },
      {
        "name": "DIGIT_MAP_SEARCH_TYPE",
        "value": "['2' => SearchType::MEETINGS, '3' => SearchType::JFT]"
      }
    ],
    "links": [],
    "workingDirectory": "/var/www/html",
    "readonlyRootFilesystem": null,
    "image": "${aws_ecr_repository.vphone.repository_url}:latest",
    "command": [
      "sh",
      "-c",
      "/tmp/startup.sh"
    ],
    "user": null,
    "dockerLabels": null,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.vphone.name}",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "vphone"
      }
    },
    "cpu": 700,
    "privileged": null,
    "memoryReservation": 512,
    "linuxParameters": {
      "initProcessEnabled": true
    }
  }
]
EOF
}