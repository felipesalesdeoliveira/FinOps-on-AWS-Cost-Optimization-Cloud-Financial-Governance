import boto3
import os


def lambda_handler(event, context):
    ec2 = boto3.client("ec2")
    filters = [
        {"Name": "instance-state-name", "Values": ["running"]},
        {"Name": "tag:AutoStop", "Values": ["true", "True", "TRUE"]},
    ]

    reservations = ec2.describe_instances(Filters=filters).get("Reservations", [])
    instance_ids = []
    for reservation in reservations:
        for instance in reservation.get("Instances", []):
            instance_ids.append(instance["InstanceId"])

    if not instance_ids:
        return {"message": "No running AutoStop instances found."}

    ec2.stop_instances(InstanceIds=instance_ids)
    return {"stopped_instances": instance_ids}
