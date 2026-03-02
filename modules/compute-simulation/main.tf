data "aws_ssm_parameter" "ami" {
  name = var.ami_ssm_parameter
}

data "aws_vpc" "selected" {
  id = data.aws_subnet.selected.vpc_id
}

data "aws_subnet" "selected" {
  id = var.subnet_id
}

resource "aws_security_group" "sim" {
  count       = var.enabled ? 1 : 0
  name        = "${var.name}-sim-sg"
  description = "FinOps simulation SG"
  vpc_id      = data.aws_vpc.selected.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name}-sim-sg" })
}

resource "aws_instance" "on_demand" {
  count = var.enabled ? 1 : 0

  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.sim[0].id]

  tags = merge(var.tags, var.required_tags, {
    Name      = "${var.name}-ondemand"
    Workload  = "critical"
    AutoStop  = "true"
    Pricing   = "OnDemand"
  })
}

resource "aws_spot_instance_request" "spot" {
  count = var.enabled ? 1 : 0

  ami           = data.aws_ssm_parameter.ami.value
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [aws_security_group.sim[0].id]
  wait_for_fulfillment   = false
  spot_type              = "one-time"

  tags = merge(var.tags, var.required_tags, {
    Name      = "${var.name}-spot"
    Workload  = "interruptible"
    AutoStop  = "true"
    Pricing   = "Spot"
  })
}
