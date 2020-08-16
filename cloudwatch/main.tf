provider "aws" {
	region = "us-east-1"
	#version = "1.40.0"
}

resource "aws_cloudwatch_metric_alarm" "cpu-utilization" {
  alarm_name          = "high-cpu-utilization-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  #threshold           = "80"
  threshold           = "20"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  #alarm_actions       = ["arn:aws:automate:us-east-1:ec2:reboot", var.sns_topic1]
  alarm_actions       = ["arn:aws:automate:us-east-1:ec2:reboot"]
  #ok_actions          = [aws_sns_topic.sns.arn]

  dimensions = {
    InstanceId = "${var.instance_id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "instance-health-check" {
  alarm_name          = "instance-health-check"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "1"
  alarm_description   = "This metric monitors ec2 health status"
  #alarm_actions       = ["arn:aws:automate:us-east-1:ec2:reboot", var.sns_topic1]
  alarm_actions       = ["arn:aws:automate:us-east-1:ec2:reboot"]

  dimensions = {
    InstanceId = "${var.instance_id}"
  }
}