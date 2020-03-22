resource aws_cloudwatch_log_group vphone {
  name              = "vphone"
  retention_in_days = 14
}

module notify_slack {
  source             = "terraform-aws-modules/notify-slack/aws"
  sns_topic_name     = "slack-topic-alert"
  lambda_description = "Send Alerts to Slack"
  slack_webhook_url  = var.slack_webhook_url
  slack_channel      = "virtual-phone"
  slack_username     = "alert-bot"
}

resource aws_cloudwatch_metric_alarm vphone_healthy_hosts {
  alarm_name          = "vphone-healthy-hosts"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Zero healthy nodes in Target Group"
  actions_enabled     = "true"
  alarm_actions       = [module.notify_slack.this_slack_topic_arn]
  ok_actions          = [module.notify_slack.this_slack_topic_arn]
  dimensions = {
    TargetGroup  = aws_lb_target_group.vphone.arn_suffix
    LoadBalancer = aws_lb.vphone.arn_suffix
  }
}
