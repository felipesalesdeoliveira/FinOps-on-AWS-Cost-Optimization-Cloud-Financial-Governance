import boto3
import os


def lambda_handler(event, context):
    required = [t.strip() for t in os.getenv("REQUIRED_TAGS", "Environment,Owner,Application,CostCenter").split(",")]
    sns_topic_arn = os.getenv("SNS_TOPIC_ARN")

    ec2 = boto3.client("ec2")
    sns = boto3.client("sns")

    reservations = ec2.describe_instances().get("Reservations", [])
    findings = []

    for reservation in reservations:
        for instance in reservation.get("Instances", []):
            tag_map = {t["Key"]: t["Value"] for t in instance.get("Tags", [])}
            missing = [tag for tag in required if tag not in tag_map]
            if missing:
                findings.append({
                    "instance_id": instance["InstanceId"],
                    "missing_tags": missing,
                })

    if findings and sns_topic_arn:
        sns.publish(
            TopicArn=sns_topic_arn,
            Subject="FinOps Alert: Untagged Resources",
            Message=str(findings),
        )

    return {"findings": findings, "total": len(findings)}
