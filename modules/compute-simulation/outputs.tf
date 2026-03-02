output "on_demand_instance_id" {
  value = try(aws_instance.on_demand[0].id, null)
}

output "spot_instance_request_id" {
  value = try(aws_spot_instance_request.spot[0].id, null)
}
