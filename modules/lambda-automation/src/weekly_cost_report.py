import boto3
import datetime
import os


def lambda_handler(event, context):
    ce = boto3.client("ce", region_name="us-east-1")
    sns = boto3.client("sns")

    end = datetime.date.today()
    start = end - datetime.timedelta(days=7)

    result = ce.get_cost_and_usage(
        TimePeriod={"Start": str(start), "End": str(end)},
        Granularity="DAILY",
        Metrics=["UnblendedCost"],
        GroupBy=[{"Type": "DIMENSION", "Key": "SERVICE"}],
    )

    total = 0.0
    lines = [f"Weekly AWS Cost Report ({start} to {end})"]
    for day in result.get("ResultsByTime", []):
        for group in day.get("Groups", []):
            amount = float(group["Metrics"]["UnblendedCost"]["Amount"])
            total += amount
    lines.append(f"Estimated weekly total: USD {total:.2f}")

    topic = os.getenv("SNS_TOPIC_ARN")
    if topic:
        sns.publish(
            TopicArn=topic,
            Subject="FinOps Weekly Cost Report",
            Message="\n".join(lines),
        )

    return {"weekly_cost_usd": round(total, 2)}
